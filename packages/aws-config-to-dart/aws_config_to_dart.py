import sys
import json

input_file = sys.argv[1]
output_file = sys.argv[2]

config = json.load(open(input_file))

dart_config = '''const kUserPoolId = {user_pool_id};
const kClientId = {client_id};
const kAdminPoolId = {admin_pool_id};
const kAdminClientId = {admin_client_id};
const kIdentityPoolId = {identity_pool_id};
const kRegion = {region};
const kUserBucketName = {user_bucket_name};
const kHost = {host};
const kPort = {port};
'''.format(user_pool_id=config['UserPoolId'],
           client_id=config['ClientId'],
           admin_pool_id=config['AdminPoolId'],
           admin_client_id=config['AdminClientId'],
           identity_pool_id=config['IdentityPoolId'],
           region=config['Region'],
           user_bucket_name=config['UserBucketName'],
           host=config['Host'],
           port=config['Port'])

with open(output_file, 'w') as f:
    f.write(dart_config)
