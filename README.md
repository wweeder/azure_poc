This is a POC I put together for the ford direct group. 
The purpose is to demonstrate the usage and integration of numerous Azure tools
and to show general proficiency with Azure, terraform, and Azure pipeliines in particular. 
Some of the content is sourced through Azure datalake since the group makes use of datalakes as well. 

The app content just displays on the container app after the pipeline is deployed. The pipeline and everything
else is instantiated using terraform, which I launched using Azure Shell as a temporary workspace. 

app - contains simple node.js app content for display over https
pipelines - contains the configuration for azure pipeline and is pulled when the pipeline runs
terraform - contains all the configurations for terraform
