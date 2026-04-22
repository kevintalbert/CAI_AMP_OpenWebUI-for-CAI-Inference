# AMP for Open WebUI with the CML AI Inference Service

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

You can run this repository in two ways. **Deployment 1** uses the AMP catalog and CML project tasks (`install_dependencies.py`, `run_app.py`). **Deployment 2** targets **Cloudera AI Inference Applications** (or equivalent AI Inference application hosting): you supply `entry.sh` as the application entrypoint; the platform runs it and Open WebUI behaves the same once it is open.

### Deployment 1 (AMP)

Deploy from the AMP catalog as shown below. If you do not see it in the community catalog, you can add `https://raw.githubusercontent.com/kevinbtalbert/CML_AMP_OpenWebUI-for-CML-AI-Inference/refs/heads/main/catalog-entry.yaml` to your AMP custom catalog entries.

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

Use this path when you deploy the same codebase as a **Cloudera AI Inference application** (or similar “application” workload backed by CAI Inference), not from the AMP catalog.

1. **Repository** — Point your application build at this repository (or a fork) so the working directory contains `entry.sh`, `requirements.txt`, and the rest of the project files.

2. **Launch command** — Configure the application to start with **`./entry.sh`** (or `bash entry.sh`) from the repository root. The script installs dependencies from `requirements.txt`, applies the Open WebUI `google.colab` path workaround, then runs `open-webui serve` bound to `0.0.0.0` and the port given by the platform.

3. **Environment variables** — Set at least the following (names match what `entry.sh` expects):

   | Variable | Purpose |
   | --- | --- |
   | `INFERENCE_SERVICE_BASE_URL` | Base URL for your CAI Inference model endpoint (same value you would paste for the AMP). May include a trailing `/chat/completions` segment; `entry.sh` strips it when setting `OPENAI_API_BASE_URLS` for Open WebUI. |
   | `CDSW_APP_PORT` | HTTP port the process must listen on. Inference application runtimes typically inject this; if unset locally, `entry.sh` defaults to `8080`. |

4. **Authentication token** — `entry.sh` sets `OPENAI_API_KEYS` by reading the JWT from **`/tmp/jwt`** (same pattern as `run_app.py`). Ensure your Inference application runtime provides that file so Open WebUI can call the inference API with a valid bearer token.

5. **Usage** — Open the application URL from your Inference Applications UI. Chat, attachments, and model selection work the same as in **Deployment 1**; only how the container is built and started differs.

## AMP Usage
This was tested using the modern runtime below on the most recent version at the time, `2024.10`.
```yaml
   - editor: PBJ Workbench
   - kernel: Python 3.11
   - edition: Standard
```



Copyright (c) 2026 - Cloudera, Inc.