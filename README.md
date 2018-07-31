# dotenv.sh
Shell scripts to help manage .env files within AWS.

The goal of these shell scripts is to make it easier to deploy environmental variables to Amazon Web Services (AWS) environments. Point the shell script to a `.env` and deploy it to the AWS Parameter Store. `put-dotenv.sh` deploys this file to the AWS Parameter Store based on the application and environment names you choose. The path looks something like this: `/AppName/EnvName/.env`.

## Usage
### Options
- `-a`|`--app` The name of your application
- `-e`|`--env` The name of your environment, ie, production, development, etc
- `-p`|`--profile` The aws profile used for authentication
- `-r`|`--region` Show debug messaging
- `-d`|`--debug` Output debug
- `-h`|`--help` Show help message
### Get: `sh bin/get-dotenv.sh`
#### Print to stdout
```bash 
bash bin/get-dotenv.sh --app TestApp --env TestApp-Dev
```
#### Save `.env` to file
```bash
bash bin/get-dotenv.sh --app TestApp --env TestApp-Dev .env
```
*OR (of course)*
```bash
bash bin/get-dotenv.sh --app TestApp --env TestApp-Dev > .env
```

### Put: `sh bin/put-dotenv.sh`
#### Put `.env` file
To deploy the environmental variables, you can point `put-dotenv.sh` to the file that contains all of the needed environmental variables and it'll save the file as a whole to the aforementioned `/<app>/<env>/.env` path in the AWS Parameter Store. An example is very similar to `get-dotenv.sh`:
```bash 
bash bin/put-dotenv.sh --profile flipbox --app TestApp --env TestApp-Dev .env
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
