import matplotlib.pyplot as plt
import numpy as np
from matplotlib.patches import Circle

# Get an example image
import matplotlib.cbook as cbook
size = width, height = 1920, 1080  # display with/height

for i in range(1, 7):
    image_file = cbook.get_sample_data('/home/talal/PycharmProjects/untitled/treetest'+str(i)+'.png')
    img = plt.imread(image_file)

    # Make some example data
    x = width -300*i
    y = 50 + 10 * (i-3) * (i-3)

    # Create a figure. Equal aspect so circles look circular
    fig, ax = plt.subplots(1)
    ax.set_aspect('equal')

    # Show the image
    ax.imshow(img)

    # Now, loop through coord arrays, and create a circle at each x,y pair
    circ = Circle((x, y), 200, color='yellow')
    ax.add_patch(circ)

    fig.patch.set_visible(False)
    ax.axis('off')

    # Show the image
    # plt.savefig("sun"+str(i)+".png")
    plt.show()