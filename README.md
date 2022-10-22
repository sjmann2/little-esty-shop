# Little Esty Shop

## Background and Description

"Little Esty Shop" is a fictitious e-commerce platform where merchants and administrators can manage inventory and fulfill customer invoices. Merchant features grant a merchant who is selling their products the ability to access invoices, enable and disable items, create new items, update item information, create bulk discounts for their items, and view other relevant information regarding products they are selling. Admin features grant an admin the ability to update merchants, enable/disable merchants, create merchants, and view other relevant information regarding merchants on the site. 

## [Visit our Little Esty Shop here](https://fierce-reef-86153.herokuapp.com/admin)

![little-esty-diagram](https://user-images.githubusercontent.com/99758586/192584074-cbb0df31-39ce-46bf-9198-9cae0c5cbfdf.png)

## Built With 
   ![RoR](https://img.shields.io/badge/Ruby_on_Rails-CC0000?style=for-the-badge&logo=ruby-on-rails&logoColor=white)
   ![pgsql](https://img.shields.io/badge/PostgreSQL-316192?style=for-the-badge&logo=postgresql&logoColor=white)
   ![heroku](https://img.shields.io/badge/Heroku-430098?style=for-the-badge&logo=heroku&logoColor=white) 
## Gems 
   ![rspec](https://img.shields.io/gem/v/rspec-rails?label=rspec&style=flat-square)
   ![shoulda](https://img.shields.io/gem/v/shoulda-matchers?label=shoulda-matchers&style=flat-square)
   ![capybara](https://img.shields.io/gem/v/capybara?label=capybara&style=flat-square)
   ![simplecov](https://img.shields.io/gem/v/simplecov?label=simplecov&style=flat-square)
   ![faker](https://img.shields.io/gem/v/faker?color=blue&label=faker)
   ![factory bot](https://img.shields.io/gem/v/factory_bot_rails?color=blue&label=factory_bot_rails)
   ![VCR](https://img.shields.io/gem/v/vcr?label=VCR&style=flat-square)
   ![webmock](https://img.shields.io/gem/v/webmock?label=webmock&style=flat-square)
   
## Navigating the website
### Visit the admin dashboard
``` https://esty-shop.herokuapp.com/admin ```

<img width="458" alt="Little Esty Admin Dashboard" src="https://user-images.githubusercontent.com/99758586/197358738-989d9937-eef6-4f1e-90f0-aea6be916980.png">


### Visit a specific merchant dashboard 
``` https://esty-shop.herokuapp.com/merchants/(merchant_id)/dashboard ```


<img width="589" alt="Little Esty Merchant Dashboard" src="https://user-images.githubusercontent.com/99758586/197358730-fa85f169-79f3-4538-a67b-683f052eb25e.png">

## Setup
* This project requires Ruby 2.7.4
* Fork this repository
* Clone your fork
* From the command line, run:
    * `bundle`
    * `rails db:{drop,create,migrate}`
    * `rails csv_load:all`
    * `rails s`
    
### Contributors to this project include:
[Kaelin Sleevi](https://github.com/KaelinSleevi), [Noah van Ekdom](https://github.com/noahvanekdom), [Alex Mora](https://github.com/AlexMR-93), [Sid Mann](https://github.com/sjmann2)
