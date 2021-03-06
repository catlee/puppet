# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.
class aws_manager::cron {
    include aws_manager::settings
    include users::buildduty
    include users::builder
    include packages::mozilla::py27_mercurial
    $repo_root = "${aws_manager::settings::cloud_tools_dst}"
    $cron_switch = $aws_manager::settings::cron_switch

    if $cron_switch == present {
        motd { "aws-manager":
            content => "** This is the distinguished aws-manager; crontasks are enabled here.\n";
        }
    } else {
        motd { "aws-manager":
            content => "** This is a standby aws-manager; crontasks are disabled here.\n*** The distinguished aws-managers is ${aws_manager::settings::distinguished_aws_manager}\n";
        }
    }

    aws_manager::crontask {
        "aws_watch_pending.py":
            ensure          => $cron_switch,
            minute          => '*/5',
            process_timeout => 3600,
            cwd             => "${aws_manager::settings::cloud_tools_dst}/scripts",
            virtualenv_dir  => "${aws_manager::settings::root}",
            user            => "${users::buildduty::username}",
            params          => "-k ${aws_manager::settings::secrets_dir}/aws-secrets.json -c ${repo_root}/configs/watch_pending.cfg -r us-west-2 -r us-east-1 -l ${aws_manager::settings::root}/aws_watch_pending.log";
        "aws_stop_idle.py":
            ensure          => $cron_switch,
            minute          => '*/10',
            process_timeout => 1200,
            cwd             => "${aws_manager::settings::cloud_tools_dst}/scripts",
            virtualenv_dir  => "${aws_manager::settings::root}",
            user            => "${users::buildduty::username}",
            params          => "-k ${aws_manager::settings::secrets_dir}/aws-secrets.json -u ${users::builder::username} --ssh-key ${users::buildduty::home}/.ssh/aws-ssh-key -r us-west-2 -r us-east-1 -j32 -l ${aws_manager::settings::root}/aws_stop_idle.log -t bld-linux64 -t tst-linux64 -t tst-linux32 -t tst-emulator64 -t try-linux64 -t av-linux64";
        "aws_sanity_checker.py":
            ensure         => $cron_switch,
            hour           => '6',
            minute         => '0',
            cwd            => "${aws_manager::settings::cloud_tools_dst}/scripts",
            virtualenv_dir => "${aws_manager::settings::root}",
            user           => "${users::buildduty::username}",
            params         => "-r us-west-2 -r us-east-1 -r us-west-1 --events-dir ${aws_manager::settings::events_dir}";
        "tag_spot_instances.py":
            ensure         => $cron_switch,
            minute         => '*/5',
            cwd            => "${aws_manager::settings::cloud_tools_dst}/scripts",
            virtualenv_dir => "${aws_manager::settings::root}",
            user           => "${users::buildduty::username}",
            params         => "-r us-west-2 -r us-east-1 -q";
        "spot_sanity_check.py":
            ensure         => $cron_switch,
            minute         => '*/10',
            cwd            => "${aws_manager::settings::cloud_tools_dst}/scripts",
            virtualenv_dir => "${aws_manager::settings::root}",
            user           => "${users::buildduty::username}",
            params         => "-r us-west-2 -r us-east-1 -q";
        "aws_publish_amis.py":
            ensure         => $cron_switch,
            minute         => '*/30',
            cwd            => "${aws_manager::settings::cloud_tools_dst}/scripts",
            virtualenv_dir => "${aws_manager::settings::root}",
            user           => "${users::buildduty::username}";
        "delete_old_spot_amis.py":
            params         => "-c tst-linux64 -c tst-linux32 -c try-linux64 -c bld-linux64 -c tst-emulator64 -c y-2008 -c b-2008 -c av-linux64",
            ensure         => $cron_switch,
            minute         => '30',
            hour           => '1',
            cwd            => "${aws_manager::settings::cloud_tools_dst}/scripts",
            virtualenv_dir => "${aws_manager::settings::root}",
            user           => "${users::buildduty::username}";
        "try-linux64-ec2-golden":
            script         => "aws_create_instance.py",
            ensure         => $cron_switch,
            minute         => '10',
            hour           => '1',
            cwd            => "${aws_manager::settings::cloud_tools_dst}/scripts",
            virtualenv_dir => "${aws_manager::settings::root}",
            user           => "${users::buildduty::username}",
            params         => "-c ${repo_root}/configs/try-linux64 -r us-east-1 -s aws-releng -k ${aws_manager::settings::secrets_dir}/aws-secrets.json --ssh-key ${users::buildduty::home}/.ssh/aws-ssh-key -i ${repo_root}/instance_data/us-east-1.instance_data_try.json --create-ami --ignore-subnet-check --copy-to-region us-west-2 try-linux64-ec2-golden";
        "bld-linux64-ec2-golden":
            script         => "aws_create_instance.py",
            ensure         => $cron_switch,
            minute         => '15',
            hour           => '1',
            cwd            => "${aws_manager::settings::cloud_tools_dst}/scripts",
            virtualenv_dir => "${aws_manager::settings::root}",
            user           => "${users::buildduty::username}",
            params         => "-c ${repo_root}/configs/bld-linux64 -r us-east-1 -s aws-releng -k ${aws_manager::settings::secrets_dir}/aws-secrets.json --ssh-key ${users::buildduty::home}/.ssh/aws-ssh-key -i ${repo_root}/instance_data/us-east-1.instance_data_prod.json --create-ami --ignore-subnet-check --copy-to-region us-west-2 bld-linux64-ec2-golden";
        "av-linux64-ec2-golden":
            script         => "aws_create_instance.py",
            ensure         => $cron_switch,
            minute         => '15',
            hour           => '1',
            cwd            => "${aws_manager::settings::cloud_tools_dst}/scripts",
            virtualenv_dir => "${aws_manager::settings::root}",
            user           => "${users::buildduty::username}",
            params         => "-c ${repo_root}/configs/av-linux64 -r us-east-1 -s aws-releng -k ${aws_manager::settings::secrets_dir}/aws-secrets.json --ssh-key ${users::buildduty::home}/.ssh/aws-ssh-key -i ${repo_root}/instance_data/us-east-1.instance_data_prod.json --create-ami --ignore-subnet-check --copy-to-region us-west-2 av-linux64-ec2-golden";
        "tst-linux64-ec2-golden":
            script         => "aws_create_instance.py",
            ensure         => $cron_switch,
            minute         => '20',
            hour           => '1',
            cwd            => "${aws_manager::settings::cloud_tools_dst}/scripts",
            virtualenv_dir => "${aws_manager::settings::root}",
            user           => "${users::buildduty::username}",
            params         => "-c ${repo_root}/configs/tst-linux64 -r us-east-1 -s aws-releng -k ${aws_manager::settings::secrets_dir}/aws-secrets.json --ssh-key ${users::buildduty::home}/.ssh/aws-ssh-key -i ${repo_root}/instance_data/us-east-1.instance_data_tests.json --create-ami --ignore-subnet-check --copy-to-region us-west-2 tst-linux64-ec2-golden";
        "tst-linux32-ec2-golden":
            script         => "aws_create_instance.py",
            ensure         => $cron_switch,
            minute         => '25',
            hour           => '1',
            cwd            => "${aws_manager::settings::cloud_tools_dst}/scripts",
            virtualenv_dir => "${aws_manager::settings::root}",
            user           => "${users::buildduty::username}",
            params         => "-c ${repo_root}/configs/tst-linux32 -r us-east-1 -s aws-releng -k ${aws_manager::settings::secrets_dir}/aws-secrets.json --ssh-key ${users::buildduty::home}/.ssh/aws-ssh-key -i ${repo_root}/instance_data/us-east-1.instance_data_tests.json --create-ami --ignore-subnet-check --copy-to-region us-west-2 tst-linux32-ec2-golden";
        "y-2008-ec2-golden":
            script         => "aws_create_instance.py",
            ensure         => $cron_switch,
            minute         => '30',
            hour           => '1',
            cwd            => "${aws_manager::settings::cloud_tools_dst}/scripts",
            virtualenv_dir => "${aws_manager::settings::root}",
            user           => "${users::buildduty::username}",
            params         => "-c ${repo_root}/configs/y-2008 -r us-east-1 -s aws-releng -k ${aws_manager::settings::secrets_dir}/aws-secrets.json --ssh-key ${users::buildduty::home}/.ssh/aws-ssh-key -i ${repo_root}/instance_data/us-east-1.instance_data_try.json --create-ami --ignore-subnet-check --copy-to-region us-west-2 y-2008-ec2-golden";
        "b-2008-ec2-golden":
            script         => "aws_create_instance.py",
            ensure         => $cron_switch,
            minute         => '35',
            hour           => '1',
            cwd            => "${aws_manager::settings::cloud_tools_dst}/scripts",
            virtualenv_dir => "${aws_manager::settings::root}",
            user           => "${users::buildduty::username}",
            params         => "-c ${repo_root}/configs/b-2008 -r us-east-1 -s aws-releng -k ${aws_manager::settings::secrets_dir}/aws-secrets.json --ssh-key ${users::buildduty::home}/.ssh/aws-ssh-key -i ${repo_root}/instance_data/us-east-1.instance_data_prod.json --create-ami --ignore-subnet-check --copy-to-region us-west-2 b-2008-ec2-golden";
        "tst-emulator64-ec2-golden":
            script         => "aws_create_instance.py",
            ensure         => $cron_switch,
            minute         => '45',
            hour           => '1',
            cwd            => "${aws_manager::settings::cloud_tools_dst}/scripts",
            virtualenv_dir => "${aws_manager::settings::root}",
            user           => "${users::buildduty::username}",
            params         => "-c ${repo_root}/configs/tst-emulator64 -r us-east-1 -s aws-releng -k ${aws_manager::settings::secrets_dir}/aws-secrets.json --ssh-key ${users::buildduty::home}/.ssh/aws-ssh-key -i ${repo_root}/instance_data/us-east-1.instance_data_tests.json --create-ami --ignore-subnet-check --copy-to-region us-west-2 tst-emulator64-ec2-golden";
        "aws_get_cloudtrail_logs.py":
            ensure         => $cron_switch,
            minute         => '5,35',
            cwd            => "${aws_manager::settings::cloud_tools_dst}/scripts",
            virtualenv_dir => "${aws_manager::settings::root}",
            user           => "${users::buildduty::username}",
            params         => "--cache-dir ${aws_manager::settings::cloudtrail_logs_dir} --s3-base-prefix ${::config::cloudtrail_s3_base_prefix} --s3-bucket ${::config::cloudtrail_s3_bucket}";
        "aws_process_cloudtrail_logs.py":
            ensure         => $cron_switch,
            minute         => '10,40',
            cwd            => "${aws_manager::settings::cloud_tools_dst}/scripts",
            virtualenv_dir => "${aws_manager::settings::root}",
            user           => "${users::buildduty::username}",
            params         => "--cloudtrail-dir ${aws_manager::settings::cloudtrail_logs_dir} --events-dir ${aws_manager::settings::events_dir}";
        "aws_clean_log_dir.py":
            ensure         => $cron_switch,
            minute         => '15,45',
            cwd            => "${aws_manager::settings::cloud_tools_dst}/scripts",
            virtualenv_dir => "${aws_manager::settings::root}",
            user           => "${users::buildduty::username}",
            params         => "--cache-dir ${aws_manager::settings::cloudtrail_logs_dir} --events-dir ${aws_manager::settings::events_dir} --s3-base-prefix ${::config::cloudtrail_s3_base_prefix}";
    }

    file {
        "/etc/cron.d/aws-manager-update-git-clone":
            content => "*/5 * * * * ${users::buildduty::username} cd ${aws_manager::settings::cloud_tools_dst} && /usr/local/bin/git pull -q 2>&1 | logger -t 'aws-manager-update-git'\n";
    }
}
