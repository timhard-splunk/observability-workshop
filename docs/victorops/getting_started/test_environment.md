# Creating a Test Environment

## Aim

The aim of this module is to guide you through the process of creating a VM which will be monitored by SignalFx.

Once the configuration of VictorOps is complete you will use this VM to trigger an Alert from SignalFx which in turn will create an Incident within VictorOps, resulting in you getting paged.

There are two options for creating the VM, running it locally using Multipass, or using an AWS/EC2 instance.  

You will have received instructions for installing Multipass via e-mail prior to the start of the workshop.

If you were unable to create a local VM using Multipass let the Splunk Workshop Team know now so they can provide you with an AWS/EC2 instance that you can use for the workshop.

If you have not yet installed Multipass and wish to try this method first, proceed with Step **[1. Install Multipass](../test_environment/#1-install-multipass)**.

If you have already successfully installed Multipass proceed to Step **[2. Create VM using Multipass](../test_environment/#2-create-vm-using-multipass)**.

---

## 1. Install Multipass

The easiest way to test VictorOps is to use Multipass to create a local test VM which will be monitored by SignalFx.

If you do not already have Multipass installed as per the pre-joining instructions you can download the installer from [here](https://multipass.run/){: target=_blank}.

Users running macOS can install it using [Homebrew](https://brew.sh/){: target=_blank} by running:

=== "Shell Command"

    ```bash
    brew cask install multipass
    ```
---

## 2. Create VM using Multipass

### 2.1 Cloud-init

The first step is to pull down the `cloud-init` file to launch a pre-configured VM.

=== "Shell Command"

    ```bash
    WSVERSION=1.27
    curl -s \
    https://raw.githubusercontent.com/signalfx/observability-workshop/v$WSVERSION/cloud-init/victorops.yaml \
    -o victorops.yaml
    ```

### 2.2 Launch VM

Remaining in the same directory where you downloaded `victorops.yaml`, run the following commands to create your VM.

The first command will generate a random unique 4 character string. This will prevent clashes in the SignalFx UI.

=== "Shell Command"

    ``` bash
    export INSTANCE=$(cat /dev/urandom | base64 | tr -dc 'a-z' | head -c4)
    multipass launch \
    --name ${INSTANCE}-vo1 \
    --cloud-init victorops.yaml
    ```

=== "Example Output"

    ``` bash
    Launched: zevn-vo1
    ```

Make a note of your VMs Hostname as you will need it in later steps.

### 2.3 Connect to VM

Once the VM has deployed successfully, in a **new** shell session connect to the VM using the following command, replacing {==xxxx==} with the name of your VM.

=== "Shell Command"

    ``` bash
    multipass shell {==xxxx==}-vo1
    ```

=== "Example Input"

    ``` bash
    multipass shell zevn-vo1
    ```

=== "Example Output"

    ``` bash
    Last login: Tue Jun  9 15:10:19 2020 from 192.168.64.1
    ubuntu@zevn-vo1:~$
    ```

---

## 3. Install SignalFx Agent

An easy way to install the SignalFx Agent into your VM is to copy the install commands from the SignalFx UI, then run them directly within your VM.

### 3.1 SignalFx UI

Navigate to the **INTEGRATIONS** tab within the SignalFx UI, where you will find the SignalFx SmartAgent tile on the top row.

Click on the SmartAgent tile to open it...

![Integrations](../../images/victorops/integrations-tab.png){: .zoom}

...then select the **Setup** tab...

![SmartAgent](../../images/victorops/smartagent-tile.png){: .zoom}

...then scroll down to 'Step 1' where you will find the commands for installing the agent for both Linux and Windows. You need to copy the commands for Linux, so click the top **copy**{: .label-button .sfx-ui-button} button to place these commands on your clipboard ready for the next step.

![SmartAgent Install](../../images/victorops/smartagent-install.png){: .zoom}

### 3.2 Install Agent

Now paste the linux install commands into your VM Shell, the SignalFx Agent will install and after approx 1 min you should have the following result.

=== "Example Output"

    ```text
    The SignalFx Agent has been successfully installed.

    Make sure that your system's time is relatively accurate or else datapoints may not be accepted.

    The agent's main configuration file is located at /etc/signalfx/agent.yaml.
    ```

---

## 4. Check SignalFx Agent

### 4.1 Agent Status

Once the agent has completed installing run the following command to check the status

=== "Shell Command"

    ```bash
    sudo signalfx-agent status
    ```

=== "Example Output"

    ```text
    SignalFx Agent version:           5.3.0
    Agent uptime:                     2m7s
    Observers active:                 host
    Active Monitors:                  9
    Configured Monitors:              9
    Discovered Endpoint Count:        6
    Bad Monitor Config:               None
    Global Dimensions:                {host: zevn-vo1}
    GlobalSpanTags:                   map[]
    Datapoints sent (last minute):    237
    Datapoints failed (last minute):  0
    Datapoints overwritten (total):   0
    Events Sent (last minute):        18
    Trace Spans Sent (last minute):   0
    Trace Spans overwritten (total):  0

    Additional status commands:

    signalfx-agent status config - show resolved config in use by agent
    signalfx-agent status endpoints - show discovered endpoints
    signalfx-agent status monitors - show active monitors
    signalfx-agent status all - show everything
    ```

### 4.2 Check the SignalFx UI

Navigate to the SignalFx UI and click on the **INFRASTRUCTURE** tab. The click on **Hosts (Smart Agent / collectd)** under the **Hosts** section.

Find your VM and confirm it is reporting in correctly; allow a few minutes for it to appear.

![Infrastructure](../../images/victorops/sfx-infrastructure.png){: .zoom}

If it fails to appear after 3 mins, please let the Splunk Team know so they can help troubleshoot.