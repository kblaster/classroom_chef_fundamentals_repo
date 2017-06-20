name "web"
description "Web Server"
run_list "role[base]", "recipe[apache]", "recipe[apache::ohai_plugin]"
default_attributes({
  "apache" => {
    "sites" => {
      "admin" => {
        "port" => 8000
      },
      "bears" => {
        "port" => 8081
      }
    }
  }
})
