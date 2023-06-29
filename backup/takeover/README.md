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
* [On Debian machine](#machine)
* [On Docker](#docker)

<a name="machine"></a>
# On Debian machine
1. Make sure you install haproxy and jq 
2. Run the bash scipt that edit the configuration of the proxy (to edit it go [down](#json))
  ```bash
  sudo ./Graduation-Project/backup/takeover/run
  ```
3. You should be ready now

<a name="docker"></a>
# On Docker
1. Build the image
   ```bash
   docker build -t gp-traffic-takeover .
   ```
2. Run the container
   ```bash
   docker run --net=host gp-traffic-takeover
   ```

<a name="json"></a>
***welcome down :)***

To edit the haproxy.cfg using the run script. You can edit the takeover.JSON file while maintaining it have the same formats
