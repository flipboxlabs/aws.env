# dotenv.sh
Shell scripts to help manage .env files within AWS 

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
          Resource:
          - !Sub
            - 'arn:aws:ssm:*:*:parameter/${ApplicationName}/*'
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
          Resource:
          - !Sub
            - 'arn:aws:ssm:*:*:parameter/${ApplicationName}/${EnvironmentName}/*'
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
          Resource:
          - !Sub
            - 'arn:aws:ssm:*:*:parameter/${ApplicationName}/*'
```
