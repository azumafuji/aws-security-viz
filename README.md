aws-security-viz -- A tool to visualize aws security groups 
============================================================


## DESCRIPTION
  Need a quick way to visualize your current aws/amazon ec2 security group configuration? aws-security-viz does just that based on the EC2 security group ingress configuration. 

## FEATURES

* Output to any of the formats that Graphviz supports. 
* EC2 classic and VPC security groups

## INSTALLATION 
```
  $ bundle install
```
([Bundler installation](http://gembundler.com/bundle_install.html))

## USAGE

To generate the graph directly using AWS keys
```
  $ bundle exec ruby lib/visualize_aws.rb -a your_aws_key -s your_aws_secret_key -f viz.svg --color=true
```

To generate a graph and filter on the name
```
  $ bundle exec ruby lib/visualize_aws.rb -a your_aws_key -s your_aws_secret_key -g 'regex' -f viz.svg --color-true
```

Example regex to exclude certain prefixes.  This regex passed into the `-g` argument will include all groups except those prefixed by `demo-`, `test-`, or `stage-`.
```
  ^(?!(demo-|test-|stage-)).+$
```

To generate the graph using an existing security_groups.json (created using aws-cli)
```
  $ bundle exec ruby lib/visualize_aws.rb -o data/security_groups.json -f viz.svg --color
```

``` 
$ bundle exec ruby lib/visualize_aws.rb --help

Options:
  -a, --access-key=<s>     AWS access key
  -s, --secret-key=<s>     AWS secret key
  -r, --region=<s>         AWS region to query (default: us-east-1)
  -o, --source-file=<s>    JSON source file containing security groups
  -f, --filename=<s>       Output file name (default: aws-security-viz.png)
  -c, --color              Colored node edges
  -g, --group-name=<s>     Group name starts with (default: )
  -e, --egress             Show egress rules
  -h, --help               Show this message
```
## DEBUGGING

To generate the graph with debug statements, execute the following command 
```
$ DEBUG=true bundle exec ruby lib/visualize_aws.rb -a your_aws_key -s your_aws_secret_key -f viz.svg
```

If it doesn't indicate the problem, please share the generated json file with me @ whynospam-awsviz@yahoo.co.in

Execute the following command to generate the json. You will need [aws-cli](https://github.com/aws/aws-cli) to execute the command

`aws ec2 describe-security-groups`

## EXAMPLE

![](https://github.com/anaynayak/aws-security-viz/raw/master/images/sample.png)

