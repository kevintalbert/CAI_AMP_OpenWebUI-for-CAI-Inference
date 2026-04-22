# Open WebUI with the CAI Inference Service

![](/assets/catalog-icon.png)

## Overview

The Open WebUI for AI Inference Service in CML project provides a ready-to-use implementation of an open-source web interface for deploying AI models using Cloudera Machine Learning (CML). This project leverages Cloudera's AI Inference Service to connect Open WebUI to your models. You can deploy it either as an **AMP** (Applied Machine Learning Prototype) in a CML project or as a **Cloudera AI (CAI) Inference Application** that uses `entry.sh` as its launch script. The in-browser experience is the same in both cases.

The project includes scripts to set up dependencies, configure the environment, and launch the Open WebUI, providing users with an efficient way to interact with their models without needing to manage complex API integrations.

**The Open WebUI offers the following features:**

1. **Simplified Model Interaction:** Provides a user-friendly interface to interact with deployed AI models without writing code.

2. **Seamless Integration with CML:** Leverages CML’s AI Inference Service to streamline the deployment and management of machine learning models.

3. **Scalable and Customizable:** Easily scalable within the CML environment and customizable to fit specific use cases.

Below illustrates an example of the deployed AMP and leverages a simple query using Cloudera's AI Inference Service and the Open WebUI. The second example includes attaching a sample document to use as context for summarization.

![](/assets/simple-example.png)

![](/assets/example-with-attachments.png)


## Deployment

You can run this repository in two ways. **Deployment 1** uses the AMP catalog and CAI project tasks (`install_dependencies.py`, `run_app.py`). **Deployment 2** targets **Cloudera AI Inference Applications** (or equivalent AI Inference application hosting): you supply `entry.sh` as the application entrypoint; the platform runs it and Open WebUI behaves the same once it is open.

### Deployment 1 (AMP)

Deploy from the AMP catalog as shown below. If you do not see it in the community catalog, you can add `https://raw.githubusercontent.com/kevintalbert/CML_AMP_OpenWebUI-for-CML-AI-Inference/refs/heads/main/catalog-entry.yaml` to your AMP custom catalog entries.

![](/assets/amp-deployment-1.png)


Enter the required base URL for your inference service instance. You can locate this by navigating to the Model Endpoints in CML as shown below and copy/paste this into the variable slot in the AMP deployment window.

![](/assets/model-endpoints.png)

Select the "Copy" icon to copy the URL.

![](/assets/model-endpoints-details.png)

As shown in the example below and on the deployment, paste it as the AMP variable and deploy the AMP.

![](/assets/amp-deployment-3.png)

![](/assets/amp-deployment-2.png)

After the AMP is deployed, either click "Open" or navigate to the Applications tab of the project to open the application there.

![](/assets/amp-deployment-4.png)

### Deployment 2 (AI Inference Applications)

Use this path when you deploy this repository as a **Cloudera AI Inference application** (a serving workload backed by CAI Inference), instead of using the AMP catalog. The app starts via **`entry.sh`**; you wire the model endpoint and bearer token inside Open WebUI (not via `entry.sh`).

#### Create the application

In Cloudera AI, open **Applications** → **Create Application**. Pick your **environment and inference service**, set **Name** and **Subdomain** (for example `open-web-ui` / `chat`), choose **Git** as the source, and point the clone at **this** repository with entry point **`entry.sh`**. A typical Git URL is `https://github.com/kevintalbert/CML_AMP_OpenWebUI-for-CML-AI-Inference.git` (use your fork if you maintain one).

![](/assets/deploy-1.png)

On the same flow, choose **SSO** or **JWT** for how users reach the application URL, set **CPU**, **memory**, and optional **autoscale**, and add any **environment variables** you need. The platform usually sets **`CDSW_APP_PORT`** for the HTTP port. Optionally set **`INFERENCE_SERVICE_BASE_URL`** if your deployment UI allows a full URL; `entry.sh` will export `OPENAI_API_BASE_URLS` when that variable is set. If tag rules prevent storing a URL in env vars, skip it and paste the URL only in Open WebUI (next subsection). For a one-time dump of all process environment variables at startup, set **`ENTRY_SH_PRINT_ENV=1`** and check application logs, then remove it so secrets are not logged on every restart.

![](/assets/deploy-2.png)

Submit **Create Application** and wait until the app is healthy, then open its URL from the Applications list.

#### Point Open WebUI at your model (URL + bearer token)

`entry.sh` does not inject inference credentials. An administrator (or a user, depending on your policy) configures an **OpenAI-compatible** connection in Open WebUI: your CAI model endpoint base URL and a **Bearer** token from the inference service.

Open the **user** menu (bottom of the sidebar), then choose **Admin Panel** so you can use the top **Settings** area (regular **Settings** from the same menu also exposes **Connections** if you prefer per-user configuration).

![](/assets/setup-model-1.png)

In **Settings** → **Connections**, enable **OpenAI API** and add or edit a connection. Paste the **base URL** of your model endpoint (the same style of URL you would copy from **Model Endpoints** in Cloudera AI; it should end with `/v1` for OpenAI-compatible APIs).

![](/assets/setup-model-2.png)

Open **Edit connection** (gear on the connection). Set **Auth** to **Bearer**, paste the inference **API key or access token**, then **Save**. After that, pick the model from the chat **Select a model** control and run a prompt as usual.

![](/assets/setup-model-3.png)

Chat, attachments, and model selection behave the same as in **Deployment 1**; only deployment and how credentials are supplied differ.





Copyright (c) 2026 - Cloudera, Inc.