                      Internet
                          |
                          |
                NLB DNS Name (Public)
               (Network Load Balancer)
              --------------------------------
              |              |               |
          AZ-1 Public     AZ-2 Public     AZ-3 Public
           Subnet            Subnet           Subnet
              |               |                |
        -----------------------------------------------
        |               |               |
   Private Subnet     Private Subnet     Private Subnet
      (AZ-1)             (AZ-2)             (AZ-3)
        |                   |                   |
     EC2 Instance        EC2 Instance        EC2 Instance
     (Nginx)             (Nginx)             (Nginx)
        |                   |                   |
   Target Group (TCP : 80 / 443 – NLB)
        |
   Health Checks (TCP)

        ↑
        |
   NAT Gateway (one per AZ – best practice)
        |
   Internet Gateway
