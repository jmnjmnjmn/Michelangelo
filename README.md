# MusiCloud
Ruby on Rails Project for CS 219
=======
## Team: Michelangelo

## Project Description

### Music sharing

Are you tired of listening to radios and billboards over and over again? You'd either have to put up with a lot of songs that are noises to your ears, or listen to your favorite songs over and over again until you get annoyed of it. Then you think you've had enough, so you go and spend a lot of time hunting for new songs to give your playlist a new look. This could be really an annoying experience.

But don't worry! Our MusiCloud is the perfect solution to your dilemma. At MusiCloud, you can share songs with your friends, and like and comment on your friends' posted musics. What's more, you can even share playlists of songs, which shows your friends your music collections and your music tastes. Therefore, you can simply listen to your friends' playlists with similar music tastes when you want to listen to some music while you're working or studying, without having to live with your old playlists that you have listened to a million times, or take the trouble to discover new good songs.

Moreover, if you do not have many friends, MusiCloud still has a handful for you. We have this awesome feature called "What's hot", which shows you the trending hashtags of all the musics that our users share on MusiCloud, and you can click into those hashtags to see all the relevant trending musics. And for example, if you like Jazz, you can click into the tag "Jazz" and find all Jazz music.

### Audio sharing

Some of you have talents in singing or playing instruments. You might want to show your talents to your friends, but all you can do is to take the pains to set up your phone or laptop to record a video of you and upload it to Instagram or Facebook. This is troublesome. But with MusiCloud, you can simply record your voice with your phone or any device and upload this piece of audio to our website to share it with your friends. Or, you might also record a piece of live music at a concert or a show and share it on MusiCloud.

Also at times you might want to express how you feel or share what you are up to at the moment. Many people type it out and tweet it, but many others remain silent and do not bother to do it. With MusiCloud, you can simply record a voice memo with your phone and share it on our website. This is much like an audio version of Twitter.


# Scalable Internet Services Templates

## Single Instance Templates

Both the app server, and database are located on a single EC2 instance.

* __NGINX + Passenger__ (Recommended for regular testing):  
  NGINX handles requests to port 80 and passes connections to instances of the
  app through Passenger. Multiple concurrent connections are supported.
    * (UCLA) https://scalableinternetservices.s3.amazonaws.com/SinglePassenger.json
    * (UCSB) https://cs290b.s3.amazonaws.com/SinglePassenger.json
* __NGINX + Passenger + memcached__:  
  Same as above, with the addition of using memcached through the `dalli` gem.
    * (UCLA) https://scalableinternetservices.s3.amazonaws.com/SinglePassengerMemcached.json
    * (UCSB) https://cs290b.s3.amazonaws.com/SinglePassengerMemcached.json
* __Puma__:  
  Puma allows both thread-based and process-based concurrency.
    * (UCLA) https://scalableinternetservices.s3.amazonaws.com/SinglePuma.json
    * (UCSB) https://cs290b.s3.amazonaws.com/SinglePuma.json
* __Puma + memcached__:  
  Same as above, with the addition of using memcached through the `dalli` gem.
    * (UCSB) https://cs290b.s3.amazonaws.com/SinglePumaMemcached.json
* __WEBrick__ (Use only for slow-performance testing):  
  WEBrick handles requests to port 80 directly, permitting only a single
  connection at a time.  
    * (UCLA) https://scalableinternetservices.s3.amazonaws.com/SingleWEBrick.json


## Multiple Instance Templates

These templates launch stacks where a load balancer (ELB) distributes requests
across a cluster app server EC2 instances. Each instance in cluster is
configured to work as described above for its corresponding type.

* __NGINX + Passenger__:
    * (UCLA) https://scalableinternetservices.s3.amazonaws.com/MultiPassenger.json
    * (UCSB) https://cs290b.s3.amazonaws.com/MultiPassenger.json
* __NGINX + Passenger + mecmached__:
    * (UCLA) https://scalableinternetservices.s3.amazonaws.com/MultiPassengerMemcached.json
    * (UCSB) https://cs290b.s3.amazonaws.com/MultiPassengerMemcached.json
* __Puma__:
    * (UCLA) https://scalableinternetservices.s3.amazonaws.com/MultiPuma.json
    * (UCSB) https://cs290b.s3.amazonaws.com/MultiPuma.json
* __Puma + mecmached__:
    * (UCLA) https://scalableinternetservices.s3.amazonaws.com/MultiPumaMemcached.json
    * (UCSB) https://cs290b.s3.amazonaws.com/MultiPumaMemcached.json

## Other Templates

* __Tsung__:  
  This instance provides an installed version of Tsung at your disposal. You
  will need to copy/rsync over your tsung xml tests.
    * (UCLA) https://scalableinternetservices.s3.amazonaws.com/Tsung.json
    * (UCSB) https://cs290b.s3.amazonaws.com/Tsung.json

## Running your own instance configuration

Add the file `.rails_initialize` to the root of your application's
repository. This should contain commands that execute as the ec2-user just
after running `rake db:migrate`. Commands that require root should be prefixed
with `sudo`. An example is provided below:

__.rails_initialize__

    rake db:seed

If you need to execute commands before installing gems, add the file
`.ec2_initialize` to the root of your application's repository. This should
contain commands that execute as the ec2-user just *before* running `rake
db:migrate`. Commands that require root should be prefixed with `sudo`. An
example is provided below:

__.ec2_initialize__

    sudo yum install -y ImageMagick

## Configuring NGINX

NGINX is provided through _passenger-standalone_, and NGINX + Passenger is
configured to start in the cloudformation templates via the command `passenger
start`. If you would like to adjust some of the NGINX settings you can do two
things:

First, add a `Passengerfile.json` file to the root of your repository. In this
file you can specify a number of NGINX options as listed in this document:
https://www.phusionpassenger.com/documentation/Users%20guide%20Standalone.html#config_file

Second, if the few options that can be provided in `Passengerfile.json` is not
sufficient, you can provide your own nginx template. Add the following to the
json dictionary in `Passengerfile.json`:

    "nginx_config_template": "nginx.conf"

Then create the file `nginx.conf` in the root of your repository with whatever
NGINX configuration you require.

# scalable_admin.py

Provides the functionality necessary to administrate github and AWS for the
purposes of Scalable Internet Services classes.


## Set up

__Resolve python dependencies via__:

    python setup.py install

__Configure AWS credentials by creating/editing the file `~/.aws/credentials`
so that it contains an `admin` section__:

    [admin]
    aws_access_key_id = ADMIN_USER_ACCESS_KEY
    aws_secret_access_key = ADMIN_USER_SECRET_ACCESS_KEY

These credentials should correspond to a user that has full permission to the
AWS API for the AWS account.

You will automatically be prompted for your github credentials the first time
you issue a `gh` command. An access token will be saved to
`~/.config/github_creds`. The github account you use should have admin rights
to the github organization.

__Create/update `$(HOME)/.config/scalable_admin.json`

The file has three keys that need to be set:

* __aws_region__: Set this value to permit students access to that single AWS
  region.

* __github_organization__: Set this value to reflect your github organization.

* __s3_bucket__: Set this value to reflect the S3 bucket where you would like
  your cloudformation templates to be stored. Teams will also be permitted to
  PUT/GET items from `s3_bucket/TEAMNAME/`.

Below is an example of the contents of the json file:

```json
{
"aws_region": "us-east-1",
"github_organization": "scalableinternetservices",
"s3_bucket": "cs290b"
}
```

## Commands

### scalable_admin aws TEAM...

Use this command to configure the AWS permissions for one ore more
teams. On first run for a team this command will create the account, outputting
the newly created credentials, and create the team's keypair file: `TEAM.pem`.

Subsequent runs can be used to make updates to a team's permissions. This is
only necessary if the permission settings have been modified in the
`scalable_admin.py` file.

### scalable_admin aws-cleanup

This command will delete stacks that are more than 8 hours old. It is useful to
run this as a cron job. The following crontab entry will run this command every
hour on the 31st minute:

    31 * * * * /path/to/the/script/utils/scalable_admin.py aws-cleanup

### scalable_admin aws-purge TEAM...

Use this command to completely remove one or more teams' permissions. This
command may fail if the AWS user for the team was manually modified through the
IAM web interface.

### scalable_admin aws-update-all

Use this command to update the permissions for all teams. The list of teams is
dynamically determined from the security group names excluding those that begin
with `default`.

### scalable_admin cftemplate [--no-test] [--multi] [--memcached] [--puma]

This command will generate a cloud formation template usable by any of the
teams configured via `scalable_admin.py aws TEAM...`. On success, the S3 url to
the generated cloudformation template will be output. The templates will be
stored in `S3_BUCKET`.

__Note__: Regenerating templates will overwrite existing templates. Hence, by
default, template names (before the `.json` extension) are suffixed with
`Test`. When you are sure you want to replace the _production_ template, use
the `--no-test` option when generating the template.

By default all EC2 instances use the Amazon Linux AMI corresponding to their
region and instance type as specified in `CFTemplate.DEFAULT_AMIS`. These
values should be updated as Amazon releases newer versions of the AMI.

The `--multi` flag is used to generate a cloudformation template utilizing a
load balancer to distribute requests to 1 to 8 app EC2 instances, backed by an
RDS database instance. When `--multi` is not not provided, the cloudformation
template will result in a stack that runs on a single EC2 instance.

By default app instances that are served via _passenger-standalone_. The
`--puma` option can be provided to use Puma as the application server.

The `--memached` flag will add memcached to the stack. When used in combination
with `--multi`, memcached will run on its own instance, otherwise it'll share
the same EC2 instance with the app server and database.

### scalable_admin cftemplate tsung [--no-test]

Generate a cloudformation template to generate stacks that run the load testing
tool funkload. The `--no-test` flag works as described above.

### scalable_admin cftemplate-update-all [--no-test]

Update all permutations of the application server stacks (not tsung). This is
useful to quickly change the allowable instance types, or to make any changes
that should apply to all app-server templates.

### scalable_admin gh TEAM USER...

Use this command to create a git repository, if it does not already exist, and
add invite list of github USERs to the repository if they have not already been
invited. Multiple users can be specified, and should be separated by
spaces. Each USER should be the student's github account name.

Subsequent exections of the command is additive, thus it will not remove
associated/invited accounts that are not specified on the command line.


## Team Members

| ![zytp9](https://media.licdn.com/mpr/mpr/shrink_200_200/p/6/005/083/26c/08e7c30.jpg) | ![kaywsy](https://media.licdn.com/mpr/mpr/shrinknp_200_200/AAEAAQAAAAAAAABqAAAAJDk5YzhkNzQwLTY2MWUtNDBiNC1iYWE4LTA5YTQ3NjkwNDZlNw.jpg) | ![jmnjmnjmn](https://media.licdn.com/mpr/mpr/shrink_200_200/p/7/005/098/35e/35aa40e.jpg) | ![candysweetyqi](https://media.licdn.com/mpr/mpr/shrink_200_200/AAEAAQAAAAAAAAEfAAAAJGIxZmI5NTI1LTZhMDgtNDE3Mi04MzNhLTFiMzI1OTk2MDAzMA.jpg) | ![jiecaranda](https://media.licdn.com/mpr/mpr/shrink_200_200/p/6/005/0ae/18a/236cf1b.jpg)
| :------------: | :------------: | :------------: | :------------: | :------------: | 
| Yuntao Zhao | Shuyuan Wang | Mengnan Jia | Qi Shao | Jie Yu
| [@zytp9](https://github.com/zytp9) | [@kaywsy](https://github.com/kaywsy) | [@jmnjmnjmn](https://github.com/jmnjmnjmn) | [@candysweetyqi](https://github.com/candysweetyqi) | [@jiecaranda](https://github.com/jiecaranda)

## Pivotal Tracker Link
##<a href="https://www.pivotaltracker.com/n/projects/1321110">Pivotal Tracker</a>
https://www.pivotaltracker.com/n/projects/1321110

