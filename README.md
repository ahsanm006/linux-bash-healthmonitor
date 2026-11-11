# Linux Bash Health Monitoring and Automation

## Overview

A Bash-based system monitoring script developed on Linux Mint to automate basic Linux system administration and health checks.

The script monitors CPU usage, memory utilisation, disk space, network connectivity, Nginx service status and system uptime.

It records monitoring results in a timestamped log file and can be scheduled to execute automatically using Cron.

## Features

- CPU utilisation monitoring
- RAM utilisation monitoring
- Disk space monitoring
- Network connectivity checks
- Nginx service health checks
- System uptime reporting
- Configurable resource thresholds
- Timestamped logging
- Automated execution using Cron

## Technologies Used

- Linux Mint 22.1
- Bash scripting
- Linux system utilities
- Cron
- Nginx
- Git and GitHub
- Stress-ng
- ShellCheck

## Installation

Clone the repository:

    git clone https://github.com/YOUR_GITHUB_USERNAME/linux-bash-health-monitor.git

Navigate into the project:

    cd linux-bash-health-monitor

Make the script executable:

    chmod +x health_check.sh

Run the script:

    ./health_check.sh

## Configuration

The following default thresholds are configured in the script:

- CPU: 80%
- Memory: 80%
- Disk: 80%

These can be changed in the configuration section of the script.

## Automated Execution

The script can be scheduled using Cron.

Example: execute every five minutes.

    */5 * * * * /absolute/path/to/health_check.sh

## Testing

The monitoring functionality was tested by:

- Stopping and restarting the Nginx service.
- Generating CPU load using stress-ng.
- Temporarily disconnecting network connectivity.
- Checking generated monitoring logs.

## Future Improvements

- Send email notifications when thresholds are exceeded.
- Add log rotation.
- Monitor multiple Linux servers remotely using SSH.
- Export monitoring metrics for Prometheus.
- Add automatic service recovery.

## Author

Created as a Linux administration and Bash automation portfolio project.
