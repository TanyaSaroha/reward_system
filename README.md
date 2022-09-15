# Reward System
###### Problem Statement:
Implementing a system for calculating rewards based on referrals of customers.
```
Sample Input
2018-06-12 09:41 A recommends B
2018-06-14 09:41 B accepts
2018-06-16 09:41 B recommends C
2018-06-17 09:41 C accepts
2018-06-19 09:41 C recommends D
2018-06-23 09:41 B recommends D
2018-06-25 09:41 D accepts
```
The invite sender gets (1/2)^k points for each confirmed invitation, where k is the level of the invitation. So this would compute as

```
{ “A”: 1.75, “B”: 1.5, “C”: 1 }
```
### Proposed Solution in Ruby

I have created one service which accepts a file with all actions and their details. It validates the input file, creates a mapping of all actions between users and then calculates individual points.
```
service = Rewards::Driver.new(params["file"])
service.get_points
```

#### Running Locally
- Ruby Version - 2.7.5
- Rails Version - 7.0.3
- Clone the repository using
```
git clone git@github.com:TanyaSaroha/reward_system.git
```
- Go to the cloned repo
```
cd reward_system
```
- Inside the repo, first install the dependencies using
```
bundle install
```
- Once the dependencies are successfully installed you can start server using
```
rails s
```

- Once you have your running server - You can call the Web service endpoint with request body contains only the file. It returns the total points for each user in reponse.

 - Using cURL

    ```
    curl -X POST -F 'file=@lib/input' http://localhost:3000/rewards
    ```
        
    Note: The path of the  in above request file is relative. Test input file is placed inside the repo: lib/input

  - Using Postman or any other API platform:

    ```
    Endpoint: POST http://localhost:3000/rewards
    Body: {file: attachment}
    ```

#### Running Specs
- Added rspec specs for the web endpoint as well as service objects.
- To run - You can use the following command:
```
    rspec spec/
```

#### Assumptions
- Input will come in a file in simple text format with every action in different line.
- Only sending invites and accepting invites are the 2 actions that take place.
- For people joining without referral, defined a user as super parent

#### Flow:
- For every request, create a new instance of ReferralMap class.
- For each ReferralMap we have details of multiple users. (Objects of Item Class) 
- We scan rows one by one in the order given in the file and create the mappings for parent(invite sender) and child (invite received). Same user cannot be added multiple times.
- For each row If action being done is recommends - we add users to the mapping. Otherwise if action is accepts, we reward points to all it's parents.
- Once we are done adding all rows, we can get total points..
