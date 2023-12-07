# zenodo-upload
upload big files to Zenodo.org using cURL, jq and bash

Uploading big files to https://zenodo.org from the commandline using the [Zenodo API](http://developers.zenodo.org/) is not straight forward. [zenodo_upload.sh](./zenodo_upload.sh) tries to make this a little easier. 

Inspired by Max Ogden's gist at https://gist.github.com/maxogden/b758cf0fe6d353846ef9ce7d03fdca0c .

# prerequisites

1. [jq](https://stedolan.github.io/jq/)
2. curl 
3. bash 

# usage

1. open a terminal
2. clone this repository
3. set environment variable ```ZENODO_TOKEN``` to Zenodo access token (see https://zenodo.org/account/settings/applications/tokens/new/) 
```bash
export ZENODO_TOKEN=[Zenodo access token]
```
4. create a new publication in Zenodo using the web ui, enter some information (e.g., title) and click ```save```
5. in the browser, copy the deposition id (e.g., in ```https://zenodo.org/deposit/12345``` , 12345 is the deposition id)
6. in terminal and upload a file using
```bash
./zenodo_upload.sh [deposition id] [filename] [--verbose/-v, optional]
```
7. on completion, you should see something like:
```shell
+ curl ...
######################################################################## 100.0%
```
8. in the web ui, refresh the deposition page and observe that the file was uploaded.


