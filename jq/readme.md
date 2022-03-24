# Processing JSON using jq

# https://github.com/genzouw/docker-jq

####################
####################
#
#

jq is useful to slice, filter, map and transform structured json data.

## Installing jq

### On Mac OS

`brew install jq`

### On AWS Linux

Not available as yum install on our current AMI. It should be on the latest AMI though: https://aws.amazon.com/amazon-linux-ami/2015.09-release-notes/

Installing from the source proved to be tricky.

## Useful arguments

When running jq, the following arguments may become handy:

| Argument        |  Description  |
| ----------------| :------------:|
| `--version`| Output the jq version and exit with zero. |
| `--sort-keys` | Output the fields of each object with the keys in sorted order.|

## Basic concepts

The syntax for jq is pretty coherent:

| Syntax  |  Description  |
| --------| :------------:|
| , | Filters separated by a comma will produce multiple independent outputs|
| ? | Will ignores error if the type is unexpected |
| [] | Array construction |
| {} | Object construction |
| + | Concatenate or Add |
| - | Difference of sets or Substract |
| length | Size of selected element |
| &#124; | Pipes are used to chain commands in a similar fashion than bash|


## Dealing with json objects

| Description | Command |
| ------------| :-----: |
| Display all keys | `jq 'keys'` |
| Adds + 1 to all items | `jq 'map_values(.+1)'` |
| Delete a key| `jq 'del(.foo)'` |
| Convert an object to array | `to_entries &#124; map([.key, .value])` |

## Dealing with fields

| Description | Command |
| ------------| :-----: |
| Concatenate two fields| `fieldNew=.field1+' '+.field2` |


## Dealing with json arrays

### Slicing and Filtering

| Description | Command |
| ------------| :-----: |
| All | `jq .[]` |
| First |	`jq '.[0]'` |
| Range | `jq '.[2:4]'` |
| First 3 | `jq '.[:3]'` |
| Last 2 | `jq '.[-2:]'` |
| Before Last | `jq '.[-2]'`|
| Select array of int by value | `jq 'map(select(. >= 2))'` |
| Select array of objects by value| ** jq '.[] &#124; select(.id == "second")'** |
| Select by type | ** jq '.[] &#124; numbers' ** with type been arrays, objects, iterables, booleans, numbers, normals, finites, strings, nulls, values, scalars |

### Mapping and Transforming

| Description | Command |
| ------------| :-----: |
| Add + 1 to all items | `jq 'map(.+1)'` |
| Delete 2 items| `jq 'del(.[1, 2])'` |
| Concatenate arrays | `jq 'add'` |
| Flatten an array | `jq 'flatten'` |
| Create a range of numbers | `jq '[range(2;4)]'` |
| Display the type of each item| `jq 'map(type)'` |
| Sort an array of basic type| `jq 'sort'` |
| Sort an array of objects | `jq 'sort_by(.foo)'` |
| Group by a key - opposite to flatten | `jq 'group_by(.foo)'` |
| Minimun value of an array| `jq 'min'` .See also  min, max, min_by(path_exp), max_by(path_exp) |
| Remove duplicates| `jq 'unique'` or `jq 'unique_by(.foo)'` or `jq 'unique_by(length)'` |
| Reverse an array | `jq 'reverse'` |



FROM gcr.io/google_containers/ubuntu-slim:0.4
MAINTAINER Shingo Omura <everpeace@gmail.com>

# Disable prompts from apt.
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update -y &&\
 apt-get install -y --no-install-recommends curl jq bash dnsutils ca-certificates && \
 apt-get autoremove -y && \
 apt-get clean -y && \
 rm -rf /tmp/* /var/tmp/* /var/cache/apt/archives/* /var/lib/apt/lists/*

CMD ["tail", "-F", "-n0", "/etc/hosts" ]



docker-jq
Docker Cloud build status Docker Pulls Docker Cloud Automated build

dockeri.co

Description
This is Dockerfile repository that wrap jq command.

This docker image is very small to use comand line.

Please refer to the official website of jq for how to use jq command.
Please contact me anytime if you have a problem or request! My information is posted at the bottom of this document.
Docker images can be referenced from the following page.

Docker Hub
Requirements
Docker
Installation
$ docker pull genzouw/jq
Usage
Please refer to the official website of jq for how to use jq command.

$ echo '{ "x":1, "y":"c" }' | docker run -i genzouw/jq .
{
  "x": 1,
  "y": "c"
}

$ echo '{ "x":1, "y":"c" }' | docker run -i genzouw/jq -c .
{"x":1,"y":"c"}

$ echo '{ "x":1, "y":"c" }' | docker run -i genzouw/jq -c .y
"c"

$ echo '{ "x":1, "y":"c" }' | docker run -i genzouw/jq -rc .y
c
It is more convenient to put the following aliases in the ~/.bashrc or ~/.zshrc file.

$ alias jq='docker run -i genzouw/jq'
License
This software is released under the MIT License, see LICENSE.

Author Information
genzouw

Twitter : @genzouw ( https://twitter.com/genzouw )
Facebook : genzouw ( https://www.facebook.com/genzouw )
LinkedIn : genzouw ( https://www.linkedin.com/in/genzouw/ )
Gmail : genzouw@gmail.com
