import matplotlib.pyplot as plt
import matplotlib.patches as patches

def draw_mmap_file_mapping(ax):
    ax.set_title("1. mmap() File Mapping", fontsize=12)
    ax.axis('off')
    ax.set_xlim(0, 10)
    ax.set_ylim(0, 5)
    ax.add_patch(patches.Rectangle((1, 1), 2, 1, facecolor="#D9EDF7", edgecolor='black'))
    ax.text(2, 1.5, "File\n(example.txt)", ha='center', va='center', fontsize=10)
    ax.add_patch(patches.Rectangle((6, 1), 2, 1, facecolor="#F7ECDE", edgecolor='black'))
    ax.text(7, 1.5, "Memory\nMapped Area", ha='center', va='center', fontsize=10)
    ax.annotate("", xy=(6, 1.5), xytext=(3, 1.5), arrowprops=dict(arrowstyle="->", lw=1.5))

def draw_fork_cow(ax):
    ax.set_title("2. fork() with Copy-On-Write", fontsize=12)
    ax.axis('off')
    ax.set_xlim(0, 10)
    ax.set_ylim(0, 6)
    ax.add_patch(patches.Rectangle((1, 4), 2, 1, facecolor="#DFF0D8", edgecolor='black'))
    ax.text(2, 4.5, "Parent", ha='center', va='center', fontsize=10)
    ax.add_patch(patches.Rectangle((1, 1), 2, 1, facecolor="#FCF8E3", edgecolor='black'))
    ax.text(2, 1.5, "Child", ha='center', va='center', fontsize=10)
    ax.add_patch(patches.Rectangle((6, 2.5), 2, 1, facecolor="#D9EDF7", edgecolor='black'))
    ax.text(7, 3.0, "Shared Memory", ha='center', va='center', fontsize=10)
    ax.annotate("", xy=(6, 3), xytext=(3, 4.5), arrowprops=dict(arrowstyle="->", lw=1.5))
    ax.annotate("", xy=(6, 3), xytext=(3, 1.5), arrowprops=dict(arrowstyle="->", lw=1.5))

def draw_malloc_vs_mmap(ax):
    ax.set_title("3. malloc() vs mmap()", fontsize=12)
    ax.axis('off')
    ax.set_xlim(0, 10)
    ax.set_ylim(0, 6)
    ax.add_patch(patches.Rectangle((1, 4), 3, 1, facecolor="#DFF0D8", edgecolor='black'))
    ax.text(2.5, 4.5, "Heap\n(malloc)", ha='center', va='center', fontsize=10)
    ax.add_patch(patches.Rectangle((1, 1), 3, 1, facecolor="#FCF8E3", edgecolor='black'))
    ax.text(2.5, 1.5, "Anonymous\nmmap()", ha='center', va='center', fontsize=10)
    ax.add_patch(patches.Rectangle((6, 1), 2, 4, facecolor="#F5F5F5", edgecolor='black'))
    ax.text(7, 3, "Virtual\nAddress Space", ha='center', va='center', fontsize=10)
    ax.annotate("", xy=(6, 4), xytext=(4.2, 4.5), arrowprops=dict(arrowstyle="->", lw=1.5))
    ax.annotate("", xy=(6, 2), xytext=(4.2, 1.5), arrowprops=dict(arrowstyle="->", lw=1.5))

# Create the plot
fig, axs = plt.subplots(3, 1, figsize=(8, 12))
draw_mmap_file_mapping(axs[0])
draw_fork_cow(axs[1])
draw_malloc_vs_mmap(axs[2])
plt.tight_layout()
plt.show()
