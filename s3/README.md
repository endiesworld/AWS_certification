# AWS_certification

## S3 Bucket Naming Rules

+ Length: Bucket names must be 3-63 characters long
+ No uppercase, No underscore, No spaces in bucket names
+ Bucket name must be unique across all AWS accounts globally
+ Buckets cannot have the following prefixes:  xn-, sthree-
+ Bucket cannot have the following surfixes , -s3alias

The default maximum numbers of bucket is 100, but you can create a service request to increase to 1000 buckets
There is no theoritical maximum size for a bucket and numbers of objects in a bucket.
Files can be between 0 and 5TB
Use multi-part upload to upload files larger than 100mb.

## S3 Objects-Etags

An entity tag(ETag) is a response header that represent a resource that has changed(without the need to download).

+ Etags are part of the HTTP protocol
+ ETags are used for ravalidation for caching systems
+ ETags are useful if you want to programmatically detect content changes to S3 objects.

## S3 Object-Checksums

A checksum is used to check the sum(amount) of data to ensure the data integrity of a file. If data is downloaded and if in-transit data is loss
or mangled the checksum will determine there is something wrong with the file.

## S3 Object -Prefixes

S3 Object prefixes are strings that proceed the Object filename and is part of the Object key name.
Since all objects in a bucket are stored in a flat-structured hierarchy, Object prefixes allows for a way to organize, group and filter objects.
example "/assets/images/my-file.txt" is an object key name, "/assets/images/" is the object prefix, while my-file.txt is the object filename.
**prefixes** are not true folders.

## S3 Object-Metadata

Metadata provides information about other data but not the contents itself.
Metadata is useful for:

+ categorizing and organizing data
+ providing contents about data

## WORM

Write once read many(WORM) is a storage compliance feature that makes data immutable, you write once and the file can never be modified or deleted, but you may read unlimited times.

## S3 Object Lock

Allows you to prevent the deletion of objects in a bucket. This feature can only be turned on at the creation of a bucket.
You can use it to prevent an object from being deleted or overwritten for a fixed amount of time or indefinitely.

## Amazon S3 Bucket URI

The S3 bucket URI (Uniform Resource Identifier) is a way to reference the address of S3 bucket and S3 objects.

```bash
aws s3 cp my-file.txt s3://my-bucket/my-file.txt
```

## S3 CLI

AWS S3 CLI is made up of four types: aws s3, aws s3api, aws s3control, aws s3outposts

+ aws s3: A high level way to interact with S3 buckets and objects

```bash
aws s3 cp my-file.txt s3://my-bucket/my-file.txt
```

+ aws s3api: A low level way to interact with S3 buckets and object

```bash
aws s3api put-object \
--bucket my-bucket-name \
--key my-prefix/my-file.txt \
--body my-file.txt
```

+ aws s3control: Manaing S3 access points, S3 outposts buckets, S3 batch operations, storage lens.

```bash
aws secontrol describe-job \
--acount-id 123456789012 \
--job-id 93735294-df46-44d5-868
```

+ aws s3outposts: Manage endpoints for S3 outposts.

```bash

```

## S3 -Request Styles

When making requests by using the REST API there are two styles of request:

+ Virtual hosted-style requests: The bucket name is a subdomain on the host

```bash
DELETE /puppy.jpj HTTP/1.1
Host: examplebucket.s3.us-west-2.amazonaws.com
Date:...........
x-amz-date:..........
Authorization:.........
```

+ Path-style requests: The bucjet name is in the request path.

```bash
DELETE /puppy.jpj HTTP/1.1
Host: examplebucket.s3.us-west-2.amazonaws.com
Date:...........
x-amz-date:..........
Authorization:.........
```

## S3-Dualstack Endpoints

There are two possible endpoint when accessing Amazon S3 API

1. Standard Endpoint(Handles only IPV4 traffic) e.g <https://s3.us-east-2.amazonaws.com>
2. DaulStack Endpoint(Handles both IPV4 and IPV6 traffic) e.g <https://s3.dualstack.us-east-2.amazonaws.com>

## S3 Storage Class-Standard

+ Default storage class, designed for general purpose storage frequwntly acceessed data
+ Data Redundancy is enabled by default as data is tored in 3 or more AZs
+ Durability od 11 9's, and availability of 4 9's (99.99%)
+ Pricing: Storage per GB, per Requests, No Retrieval fee.

## S3 Storage Classes - Express One Zone

Delivers consistent single-digit millisecond data access for most frequently accessed data and latency-sensitive applications.

+ The lowest latency cloud object storage class available
+ 10X faster data access speed compared to standard
+ Request cost is 50% lower than standard
+ Data is stored in a single AZ.

## S3 Storage Classes - Glacier & Glacier Vault

Glacier is a stand-alone service that uses vaults over bucket to store data long term. Glaciers has a minimum storage days of 90, while Glacier Deep archive has a minomum storage days of 180days.

## S3 Security-Block Public Access

Block public access is a safety feature that is enabled by default to block all public access to an S3 bucket.

## S3 Security-Access Control Lists(ACLs)

ACLs grant basic read/write permissions to other AWS accounts.

+ you can grant permissions only to other AWS accounts
+ you cannot grant permissions to users in your account
+ you cannot grant conditional permissions
+ you cannot explicitly deny permissions

## S3 Security- Bucket Policies

S3 bucket policy is a resource-based policy to grant an S3 bucket and bucket objects to other Principles eg. AWS Accounts, Users, AWS services.

+ Create a bucket

```sh
aws s3 mb s3://emmanuel-bucket-policy-example-ab-5235
```

+ Create bucket policy

```sh
aws s3api put-bucket-policy --bucket emmanuel-bucket-policy-example-ab-5235 --policy file//policy.json
```

+ Access the bucket in the other account

```sh
touch client-account-file.txt
aws s3 cp client-account-file.txt s3://emmanuel-bucket-policy-example-ab-5235
aws s3 ls s3://emmanuel-bucket-policy-example-ab-5235
```

## S3 Security- Access Grants

S3 access grants lets you map identities in a directory service (IAM Identify center, Active Directory, Okta) to access datasets in S3.

## S3 Security- CORS

S3 allows you to set CORS configuration to a S3 bucket with static website hosting so different origins can perform HTTP requests from your S3 Static website.

+ Create a bucket

```sh
aws s3 mb s3://emmanuel-bucket-cors-implementation
```

+ change block public access

```sh
aws s3api put-public-access-block \
--bucket s3://emmanuel-bucket-cors-implementation \
--public-access-block-configuration "BlockPublickAcls=false,IgnorePublicAcls=true,BlockPublicPolicy=false,RestricPublicBuckets=false"
```

## S3 Security- Encryption

**Encryption In Transit:** Data is encrypted by the sender and then decrypted by the reciever via TLS or SSL.
**Server Side Encryption:** Is always on foe all new S3 objects. Types:

+ SSE-S3: Amazon S3 manages the keys, encrypts using AES-GCM (256-bit) algorithm, and does the key rotations for you.
+ SSE-KMS: AWS Key Management Service (KMS), managed by AWS and you manage the keys. KMS can help meet regulatory compliance.
+ SSE-C: Customer provided key (you manage the keys), you need to provide the encryption key everytime you retrieve objects.

## S3 - Data Consistency

When data is being kept in two different place and whether the data exactly match or do not match.
Amazon S3 offers strong consistency for all read, write, and delete operations.
Strongly Consistent, means every time you request data(query) you can expect consistent data to be returned with x time (1 sec).