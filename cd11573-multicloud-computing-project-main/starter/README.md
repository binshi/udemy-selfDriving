# Purpose of this Folder

This folder should contain the scaffolded project files to get a student started on their project. This repo will be added to the Classroom for students to use, so please do not have any solutions in this folder.

### Why DynamoDB was chosen?

DynamoDB and Azure provided NoSQL DB CosmoDB have very similar availability, pricing and scalability. However AWS provides 25 GB of data storage, 2.5 million streams read requests, and 100 GB of data transfer outs will be allocated under AWS free tier. Additionally with DynamoDB we can use on-demand capacity mode, where the total cost will be decided based on the application traffic or the provisioned capacity mode, the cost will be calculated based on the number of read and write units you define. Finally two services(MySQL and DotNet App) are already on azure and hence to balance the distribution in multicloud, we go with DynamDB. 
