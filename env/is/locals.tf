local {
   ecr = {
    name                               = "openfinance/of-out-serv-channels"
    image_tag_mutability               = "IMMUTABLE"  
    scan_on_push                       = true
    expire_older_images                = false 
    ecr_accounts_to_allow_cross_accout = ["772699454550", "253557610407", "237660832108", "584539243974"]              
    image_count_more_than_days         = 10     
   }
}