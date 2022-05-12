from ovito.io import import_file
import math
import ovito.vis as vis
import numpy as np
import ovito.modifiers as md

pipeline = import_file("/home/common/studtscm03/project_dipole/dumps/dump.dipole200")

pipeline.add_to_scene()

def mod_color_radius(frame, data):
    radius_property = data.particles_.create_property("Radius")
    color_property = data.particles_.create_property("Color")
    type_property = data.particles_.create_property("Particle Type")
    for i in range(len(radius_property)):
        if type_property.array[i] == 1:
            color_property.marray[i] = (112/250, 112/250, 112/250)
        else:
            color_property.marray[i] = (0/250, 0/250, 0/250)
        radius_property.marray[i] = 0.2
        
pipeline.modifiers.append(md.PythonScriptModifier(function = mod_color_radius))
                                                

data = pipeline.compute()

wall = data.cell[0][0]

wall_x = data.cell[0][0] 
wall_y = data.cell[1][1]
wall_z = data.cell[2][2]

vp = vis.Viewport()
vp.type = vis.Viewport.Type.Perspective

def get_pos_dir(frame):
    center = np.array([wall_x/2, wall_y/2, wall_z/2])
    radius = wall_x/2 + wall_y/2*3**0.5
    phi = frame/20*2*np.pi
    #direction = np.array([np.cos(phi),np.sin(phi),1])
    direction = np.array([0,0.6,0.8])
    return tuple(center + direction*radius), tuple(-direction)

pos, direction = get_pos_dir(0)
vp.camera_pos = pos
vp.camera_dir = direction
vp.fov = math.radians(60.0)

def render_view(args):
    pos, direction = get_pos_dir(args.frame)
    args.viewport.camera_pos = pos
    args.viewport.camera_dir = direction
    vp.fov = math.radians(60.0)
    
vp.overlays.append(vis.PythonViewportOverlay(function = render_view))
#vp.render_image(size = (400,400), filename="melt.png", renderer=vis.TachyonRenderer())
vp.render_anim(size = (400,400), filename="dipole200.mp4", renderer=vis.TachyonRenderer(), range=(0,500))