import matplotlib.pyplot as plt
import matplotlib.patches as patches

# Create the figure and axis
fig, ax = plt.subplots(figsize=(10, 7))
ax.axis('off')

# Draw User Space box
user_space = patches.FancyBboxPatch((0.1, 0.6), 0.8, 0.3,
                                    boxstyle="round,pad=0.02",
                                    edgecolor="blue", facecolor="#D0E1F9", linewidth=2)
ax.add_patch(user_space)
ax.text(0.5, 0.85, "User Space", ha='center', va='center', fontsize=14, weight='bold', color='blue')

# Draw Kernel Space box
kernel_space = patches.FancyBboxPatch((0.1, 0.2), 0.8, 0.3,
                                      boxstyle="round,pad=0.02",
                                      edgecolor="green", facecolor="#DFF2BF", linewidth=2)
ax.add_patch(kernel_space)
ax.text(0.5, 0.35, "Kernel Space", ha='center', va='center', fontsize=14, weight='bold', color='green')

# Add components in User Space
user_components = {
    "Application (e.g., ls, cat)": (0.25, 0.72),
    "User Libraries (glibc, etc.)": (0.65, 0.72),
}
for label, (x, y) in user_components.items():
    ax.text(x, y, label, ha='center', va='center', fontsize=10, bbox=dict(facecolor='white', edgecolor='blue'))

# Add components in Kernel Space
kernel_components = {
    "System Call Interface": (0.5, 0.45),
    "IPC Mechanisms\n(Pipes, Sockets,\nShared Memory)": (0.25, 0.28),
    "Process & Memory Management": (0.75, 0.28)
}
for label, (x, y) in kernel_components.items():
    ax.text(x, y, label, ha='center', va='center', fontsize=10, bbox=dict(facecolor='white', edgecolor='green'))

# Add arrows between user and kernel
ax.annotate('', xy=(0.5, 0.6), xytext=(0.5, 0.58),
            arrowprops=dict(facecolor='black', arrowstyle='->'))
ax.text(0.52, 0.59, "System Call", fontsize=9, va='top')

# Show the diagram
plt.tight_layout()
plt.show()

