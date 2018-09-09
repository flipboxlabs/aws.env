# aws.env
Shell scripts to help manage .env files within the [AWS Parameter Store](https://docs.aws.amazon.com/systems-manager/latest/userguide/systems-manager-paramstore.html).

The goal of these shell scripts is to make it easier to deploy environmental variables to Amazon Web Services (AWS) environments. Point the shell script to a `.env` and deploy it to the AWS Parameter Store. `dotenv put-dotenv` deploys this file to the AWS Parameter Store based on the application and environment names you choose. The path looks something like this: `/AppName/EnvName/.env/<VARIABLE NAME>`.

## Usage
### Options
- `-a`|`--app` The name of your application
- `-e`|`--env` The name of your environment, ie, production, development, etc
- `-p`|`--profile` The aws profile used for authentication
- `-r`|`--region` The aws region
- `-d`|`--debug` Output debug
- `-h`|`--help` Show help message
### Get: `./bin/dotenv get-dotenv`
#### Print to stdout
```bash 
./bin/dotenv get-dotenv --app TestApp --env TestApp-Dev
```
#### Save `.env` to file
```bash
./bin/dotenv get-dotenv --app TestApp --env TestApp-Dev .env
```
*OR (of course)*
```bash
./bin/dotenv get-dotenv --app TestApp --env TestApp-Dev > .env
```

### Put: `./bin/dotenv put-dotenv`
#### Put `.env` file
To deploy the environmental variables, you can point `dotenv put-dotenv` to the file that contains all of the needed environmental variables and it'll save the file as a whole to the aforementioned `/<app>/<env>/.env` path in the AWS Parameter Store. An example is very similar to `dotenv get-dotenv`:
```bash 
./bin/dotenv put-dotenv --profile flipbox --app TestApp --env TestApp-Dev .env
```

### Put Parameter: `./bin/dotenv put-parameter`
#### Put a single parameter
```bash 
./bin/dotenv put-parameter --profile flipbox --app TestApp --env TestApp-Dev DB_PASSWORD myDbSecret
```

### Delete Parameter: `./bin/dotenv delete-parameter`
#### Delete a single parameter
```bash 
./bin/dotenv delete-parameter --profile flipbox --app TestApp --env TestApp-Dev DB_PASSWORD
```

# AWS Policy Examples
You can manage permissions to the parameters by limiting access to the role/instance profile or user base on policies that specify the app and/or the environment.

The following are examples on how to restrict access via AWS CloudFormation Policies.
## Example CloudFormation to restrict user based on Application Name
```yaml
Resources:
  UserPolicy:
    Type: AWS::IAM::Policy
    Properties:
      PolicyName: UserSsmPolicy
      PolicyDocument:
        Statement:
        - Effect: Allow
          Action:
          - "ssm:GetParameters"
          - "ssm:GetParametersByPath"
          - "ssm:PutParameter"
          - "ssm:DeleteParameter"
          - "ssm:DeleteParameters"
          Resource: !Sub 'arn:aws:ssm:*:*:parameter/${ApplicationName}/*'
```

## Example CloudFormation to restrict user based on Application and Environment Name
```yaml
Resources:
  UserPolicy:
    Type: AWS::IAM::Policy
    Properties:
      PolicyName: UserSsmPolicy
      PolicyDocument:
        Statement:
        - Effect: Allow
          Action:
          - "ssm:GetParameters"
          - "ssm:GetParametersByPath"
          - "ssm:PutParameter"
          - "ssm:DeleteParameter"
          - "ssm:DeleteParameters"
          Resource: !Sub 'arn:aws:ssm:*:*:parameter/${ApplicationName}/${EnvironmentName}/*'
```


## Example CloudFormation to restrict instances to read-only based on Application Name
```yaml
Resources:
  InstanceRolePolicies:
    Type: AWS::IAM::Policy
    Properties:
      PolicyName: InstanceRole
      PolicyDocument:
        Statement:
        - Effect: Allow
          Action:
          - "ssm:GetParameters"
          - "ssm:GetParametersByPath"
          Resource: !Sub 'arn:aws:ssm:*:*:parameter/${ApplicationName}/*'
```
