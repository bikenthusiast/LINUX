import matplotlib.pyplot as plt
import matplotlib.patches as patches

# Set up the figure
fig, ax = plt.subplots(figsize=(12, 8))
ax.axis('off')

# Define colors
color_app = "#B3CDE3"
color_backend = "#FBB4AE"
color_data = "#CCEBC5"
color_obs = "#DECBE4"

# Draw frontend layer
ax.add_patch(patches.FancyBboxPatch((0.4, 0.85), 0.2, 0.08, boxstyle="round,pad=0.02", 
                                    edgecolor="black", facecolor=color_app))
ax.text(0.5, 0.89, "Frontend (Web/Mobile)", ha='center', va='center', fontsize=10)

# Draw Load Balancer
ax.add_patch(patches.FancyBboxPatch((0.4, 0.74), 0.2, 0.06, boxstyle="round,pad=0.02",
                                    edgecolor="black", facecolor="#f0e68c"))
ax.text(0.5, 0.77, "Load Balancer", ha='center', va='center', fontsize=10)

# Draw backend services
backend_services = ["Auth Service", "User Service", "Billing Service", "API Gateway"]
for i, service in enumerate(backend_services):
    x = 0.15 + i * 0.2
    ax.add_patch(patches.FancyBboxPatch((x, 0.62), 0.15, 0.08, boxstyle="round,pad=0.02", 
                                        edgecolor="black", facecolor=color_backend))
    ax.text(x + 0.075, 0.66, service, ha='center', va='center', fontsize=9)

# Draw Message Queue
ax.add_patch(patches.FancyBboxPatch((0.4, 0.5), 0.2, 0.06, boxstyle="round,pad=0.02",
                                    edgecolor="black", facecolor="#FFDAB9"))
ax.text(0.5, 0.53, "Message Queue (Kafka/SQS)", ha='center', va='center', fontsize=9)

# Draw data layer
data_services = ["PostgreSQL", "Redis", "S3/Blob", "ElasticSearch"]
for i, db in enumerate(data_services):
    x = 0.1 + i * 0.22
    ax.add_patch(patches.FancyBboxPatch((x, 0.36), 0.18, 0.08, boxstyle="round,pad=0.02",
                                        edgecolor="black", facecolor=color_data))
    ax.text(x + 0.09, 0.40, db, ha='center', va='center', fontsize=9)

# Observability layer
obs_components = ["Metrics (Prometheus)", "Logs (ELK/Fluentd)", "Tracing (Jaeger)"]
for i, obs in enumerate(obs_components):
    x = 0.15 + i * 0.25
    ax.add_patch(patches.FancyBboxPatch((x, 0.2), 0.2, 0.08, boxstyle="round,pad=0.02",
                                        edgecolor="black", facecolor=color_obs))
    ax.text(x + 0.1, 0.24, obs, ha='center', va='center', fontsize=9)

# Connect components with arrows
arrow_params = dict(arrowstyle='->', color='black', lw=1)

# Frontend to Load Balancer
ax.annotate('', xy=(0.5, 0.85), xytext=(0.5, 0.82), arrowprops=arrow_params)
# Load Balancer to each backend
for i in range(4):
    x = 0.225 + i * 0.2
    ax.annotate('', xy=(0.5, 0.74), xytext=(x, 0.70), arrowprops=arrow_params)

# Backend to queue
for i in range(4):
    x = 0.225 + i * 0.2
    ax.annotate('', xy=(x, 0.62), xytext=(0.5, 0.56), arrowprops=arrow_params)

# Queue to databases
for i in range(4):
    x = 0.19 + i * 0.22
    ax.annotate('', xy=(0.5, 0.5), xytext=(x, 0.44), arrowprops=arrow_params)

# Backend to observability
for i in range(4):
    x1 = 0.225 + i * 0.2
    for j in range(3):
        x2 = 0.25 + j * 0.25
        ax.annotate('', xy=(x1, 0.62), xytext=(x2, 0.28), arrowprops=dict(arrowstyle='->', color='gray', lw=0.8))

# Display the diagram
plt.tight_layout()
plt.show()
