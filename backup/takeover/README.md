# Content
* [Notes](#Notes) 
* [Steps](#Steps) 

<a name="Notes"></a>
## Notes
* It works for one controller or more (edit the takeover.JSON)
* It can work with multuiple controller types ( different types toghther)
* It was made on ubuntu 22 but it should work with any edition
* It was tested mainly on RYU controllers but will work with other types

<a name="Steps"></a>
## Steps

1. Make sure you install haproxy and jq 
2. Run the bash scipt that edit the configuration of the proxy (to edit it go [down](#json))
  ```bash
  sudo .//Graduation-Project/backup/takeover/run
  ```
3. To verify the vaildity of the haproxy.cfg file 
  run
  ```bash
  haproxy -c -f /etc/haproxy/haproxy.cfg
  ```
4. to start the haproxy service
  run 
  ```bash
  systemctl restart haproxy.service
  ```
  ```bash
  systemctl reload haproxy.service
  ```
  ```bash
  systemctl restart haproxy.service
  ```
5. To check that the servie is active
  ```bash
  systemctl status haproxy.service
  ```
6. You should be ready now

<a name="json"></a>
***welcome down :)***

To edit the haproxy.cfg using the run script. You can edit the takeover.JSON file while maintaining it have the same formats
