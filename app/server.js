const express = require("express");

const app = express();

const port = process.env.PORT || 80;
const environment = process.env.APP_ENVIRONMENT || "unknown";
const messagePath = process.env.MESSAGE_PATH || "unset";
const buildVersion = process.env.BUILD_VERSION || "local-dev";

app.get("/", (req, res) => {
  res.type("html").send(`
    <html>
      <head><title>Welcome to Warren Weeder's Azure POC Demo!</title></head>
      <body>
        <h1>Azure POC Demo App</h1>
        <p><strong>This app was deployed with an Azure DevOps pipeline</strong></p>
        <p><strong>All infra and resources including resource group, network, container apps, devops project and azure pipeline were created with terraform which was executed from within Azure shell</strong></p>
        <p><strong>The resultant pipeline was then run to build and deploy this app</strong></p>
        <p><strong>My preferred branching strategy is a main branch with feature branches, with the app being environment agnostic and consuming environment specific parameters. This one artifact was deployed in the example QA and DEV environments, as shown in the variable values below </strong></p>
        <p><strong>I hope that you will find that this a suitable demonstration of my ability to deliver according to business needs, using whatever means are required!</strong></p>
        <p><strong>The codebase containing all terraform, pipeline and application code can be found here: https://github.com/wweeder/azure_poc </strong></p>
        <p><strong>I will be happy to screen share and show the various azure components and methods used!</strong></p>
        <p><strong>Example code version:</strong> ${buildVersion}</p>
        <p><strong>Running environment:</strong> ${environment}</p>
        <p><strong>Data lake content loaded from:</strong> ${messagePath}</p>
      </body>
    </html>
  `);
});

app.get("/health", (req, res) => {
  res.json({
    status: "ok",
    environment,
    buildVersion
  });
});

app.listen(port, () => {
  console.log(`Demo app listening on port ${port}`);
});
