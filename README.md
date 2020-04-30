# Simple website availability checker

Script loads CSV file which must have `URL` header and check availability using [net-ping](https://github.com/eitoball/net-ping) library.


## Requirements

* Internet connection
* Requires ruby version >= 1.9.3
* Installed dependencies. Run this command to install them:

  ```sh
  bundle install
  ```

* CSV file with `URL` header containing a host

## Usage

Supply CSV file path to script under project folder:

```sh
./bin/website_checker websites_to_check.csv
```

As a result prints something like this:

    google.com => OK
    raketaapp.com => OK
    somewronghost.com => FAIL