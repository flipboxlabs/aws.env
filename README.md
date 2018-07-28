# dotenv.sh
Shell scripts to help manage .env files within AWS 

# AWS Policy Examples
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
