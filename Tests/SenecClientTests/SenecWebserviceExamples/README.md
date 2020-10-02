# Senec Communication
The communication between the Client and the Senec server (the battery) has to be reverse engineered.
This file summarizes all findings, based on this reverse engineering.

## Webservice and Webinterface
The reverse engineering is based on the analysis of the web traffic between an HTTP client (Webbrowser) and the Senec server.
The Webservice consists of a single CGI-script named "lala.cgi". The information is retreived from this Webservice by submitting
an empty JSON object as content of the HTTP-request and by getting the JSON with all the values filled in.

Unfortunately the values in the JSON are encoded in a specific format and are not directly usable as standard JSON value types.

## Value Conversion

The value conversion is handled by Javascript code, which is stored in conversion.js
