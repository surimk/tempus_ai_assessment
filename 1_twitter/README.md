## 1. Design a Scalable Twitter Clone in the Cloud

### Imagine you are tasked with building a basic Twitter clone in the cloud (using GCP or another cloud platform).
#### ● Define a Minimum Viable Product (MVP): Start by outlining a basic set of features that you would include in a minimal version of the application. What core functionality must be supported?

The Minimum Viable Product will be as follows:
- There will be Users (support sign up, login, logout, store credentials)
- Users can post tweets (limited to 280 characters)
- Users can delete their own tweets
- Users can like tweets (of other users or their own)
- Users can follow other users 
- Users have a home timeline with their own tweets and those they follow
- Users can view another user's timeline of their own tweets


#### ● Identify Required Cloud Resources: Describe the cloud resources you would use to build and deploy this MVP. How would you connect and configure them?`
- DNS: Register a domain name URI on AWS Route52 so users can access the Twitter Clone. Set up a hosted zone and set up DNS (A/CNAME) records in order to point domain to the Load Balancer.

- Load Balancer: Create an AWS Application Load Balancer to distribute incoming traffic amongst multiple application servers (ex: AWS EC2 instances) in order to handle load. Need to set up listener rules for HTTP/HTTPS (port 80,443) and register the application servers onto the load balancer itself.  

- Application Servers: Front-end web servers and back-end servers will be hosted on AWS EC2. Front-end servers will generate and serve static files on to AWS S3 and relay user requests to back-end RESTful API endpoints. Back-end servers exposes RESTful APIs for these request and processes them with logic. Back-end servers should have write and read access to databases. All the servers should be registered to the Application Load Balancer for distrbuting traffic load. 

- Storage buckets: AWS S3 Buckets will be used to store static files that are to be served to the user (HTML, CSS, JavaScript). 

- Databases: Amazon RDS (PostgreSQL or MySQL) will be used for structured datasets such as user account details, tweet data, and follower/following relationships. Back-end logic will query the RDS based on request such as retrieving user's tweets and user timelines. RDS should have replicants for data availability and failsafe. Back-end servers will require read/write access to RDS instances. 

- Security:
    1. AWS Security Groups will need to be in place for EC2 instances, Application Load Balancers, and RDS instances in order to manage inbound and outbound traffic ports. 
    2. AWS IAM Roles and Policies will need to be implemented on cloud resources in order for secure communication between resources (ex: EC2 accessing RDS).
    3. SSL Certificates will need to be provisioned for secure HTTPS traffic. 

#### ● Scaling Strategy: After launching the MVP, explain how you would scale the system to handle growing user traffic. What resources or architectural changes would be necessary for scaling?
- Enabling EC2 Auto-Scaling: Setting up EC2 Auto Scaling Groups allows us to automatically scale the amount of EC2 instances needed based on load/usage, promoting elasticity and availability. Auto Scaling Groups will have to be registered on to the Application Load Balancer and AWS CloudWatch needs to be configured to determine what metric is used to scale up and down. 

- Implementing Cache Layer: Setting up a Amazon ElastiCache to store frequently accessed data. This will lead to faster retrieval for these requests, as well as, reduce load on the back-end from having to query the same request over and over again. Implementing will require creating a ElastiCache cluster and have it have the proper security group rules and IAM roles to be able to communicate with the back-end EC2 server. 

- Database Sharding: As the amount of users and traffic grows, the database itself could be a bottleneck. Sharding splits up tables based on a key (such as user_id) and store these sharded tables onto seperate databases. This reduces load on the database system by distrbuting load across multiple database instances. Implmentation will require adding additional AWS RDS instances and figuring out a sharding strategy to allocate data. 


#### ● Additional Features & Considerations: As the application grows, new features might be added. Discuss any potential additional features and the cloud resources you would need to support them.

Additional features:
- Be able to post images and videos: The next evolution of tweets is not just text, but to also support user uploaded images and video. Additional AWS S3 buckets might be required to store the larger amount of content, as well as, implementing a CDN (Content Delivery Network) such as Amazon CloudFront that caches frequently accessed media files for faster delivery.

- Searching of tweets: We can implement a search and analytics engine such as Amazon Elasticsearch in order to efficiently search and analyze tweets. We will need to be synchronize Elasticsearch with our AWS RDS databases in order to index and sync data. Back-end servers will send search queries to Elasticsearch.

- Direct messaging between users: We can implement DMs between users by creating new data models in our RDS database and implementing messaging specific back-end API endpoints on our back-end server.


#### ● Key Questions: What critical questions would you need to address as you plan the system’s architecture and scaling strategy?

Key questions are as follows:

- How will we ensure high availabilty of my system's resources?
- How will we ensure database consistency?
- What metrics and analytics will we use to scale the system?
- What tradeoffs are we expecting choosing one technology over another?
- How will we handle unexpected traffic spikes and increasing load?
- How will we secure user data and protect infrastructure?
