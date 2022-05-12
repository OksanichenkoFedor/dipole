import numpy as np
import matplotlib.pyplot as plt
import time
from multiprocessing import Pool

def input_dump(filename):
    un_found = True
    while un_found:
        un_found = False
        try:
            file = open(filename,"r")
        except:
            print("Файл не готов")
            time.sleep(1)
            un_found = True
    coords = []
    momentums = []
    timesteps = []
    moment_means = []
    atoms = 0
    ind = 0
    new_timestep = False
    adding_coords = False
    curr_coords = []
    curr_momentums = []
    curr_timestep = 0
    for line in file.readlines():
        if adding_coords:
            if "ITEM" in line:
                adding_coords = False
                curr_momentums = np.array(curr_momentums)
                coords.append(curr_coords)
                momentums.append(curr_momentums)
                timesteps.append(curr_timestep)
                moment_means.append(curr_momentums.T.mean(axis=1))
                curr_coords = []
                curr_momentums = []
                ind=0
            else:
                curr_coords.append([float(line.split()[2]),
                                    float(line.split()[3]),
                                    float(line.split()[4])])
                curr_momentums.append([float(line.split()[5]),
                                       float(line.split()[6])])
                
            #print(line.split())
        elif new_timestep:
            if   ind==1:
                curr_timestep= int(line)
            elif ind==3:
                atoms = int(line)
            #print(line)
    
        if "TIMESTEP" in line:
            new_timestep = True
        elif ("mux" in line) and ("muy" in line):
            adding_coords = True
            new_timestep = False
        
        ind+=1
    np_coords = np.array(coords)
    file.close()
    return {"coords":np.array(coords), 
            "timesteps":np.array(timesteps), 
            "momentums":np.array(momentums),
            "moment_means":np.array(moment_means)}


def plot(data,timestep=0):
    arrow_size = 0.5
    ind = 0
    while(data["timesteps"][ind]<timestep and ind<len(data["timesteps"])):
        ind+=1
    moments = data["momentums"][ind]
    coords = data["coords"][ind]
    #print(moments.shape)
    #print(coords.shape)
    plt.figure(figsize=(10, 7))
    for i in range(len(coords)):
        #plt.scatter(coords[i][0],coords[i][1],color="b")
        plt.arrow(coords[i][0]-0.5*arrow_size*moments[i][0],
                  coords[i][1]-0.5*arrow_size*moments[i][1],
                  arrow_size*moments[i][0],
                  arrow_size*moments[i][1],
                  width = 0.05,
                  head_length = 0.3*arrow_size)
    plt.suptitle('Timestep '+str(data["timesteps"][ind])+" of "+str(data["timesteps"][-1]))
    plt.xlabel("X")
    plt.ylabel("Y")
    plt.grid()
    plt.show()
    
def single_en(i):
    inds = np.arange(i+1,moments.shape[0])
    full_en = 0
    for j in inds:
        d1 = moments[i]
        d2 = moments[j]
        r = (coords[j]-coords[i])[:2]
        abs_r = np.linalg.norm(r)
        n = r*(1.0/abs_r)
        curr_en = (3*np.dot(d1,n)*np.dot(d2,n)-np.dot(d1,d2))/abs_r**3
        full_en+=curr_en
        #full_en+=1
    return full_en


def count_energy(data, timestep = 0, use_mult=False):
    
    ind=0
    while(data["timesteps"][ind]<timestep and ind<len(data["timesteps"])):
        ind+=1
    global moments
    global coords
    global Timestep
    moments = data["momentums"][ind]
    coords = data["coords"][ind]
    Timestep = timestep
    full_en = 0
    
    if not use_mult:
        inds = np.arange(moments.shape[0])
        with Pool(20) as p:
            ans = np.array(p.map(single_en, inds)).sum() / moments.shape[0]
        return ans 
    else:
        for i in range(moments.shape[0]):
            for j in range(i+1,moments.shape[0]):
                d1 = moments[i]
                d2 = moments[j]
                r = (coords[j]-coords[i])[:2]
                abs_r = np.linalg.norm(r)
                n = r*(1.0/abs_r)
                curr_en = (3*np.dot(d1,n)*np.dot(d2,n)-np.dot(d1,d2))/abs_r**3
                full_en+=curr_en
                #full_en+=1
        full_en = full_en / moments.shape[0]
        return full_en



def make_txt(num_atoms, use_mult=False, do_dumps = False):
    if do_dumps:
        curr_path = "/home/common/studtscm03/project_dipole/dumps/dump.dipole" +str(num_atoms)
    else:
        curr_path = "/home/common/studtscm03/project_dipole/scripts/dump.dipole" +str(num_atoms)
    curr_dict = input_dump(curr_path)
    en = []
    filename = "/home/common/studtscm03/project_dipole/scripts/forgnu" +str(num_atoms)+".txt"
    file = open(filename,"w")
    for i in range(len(curr_dict["timesteps"])):
        en.append(count_energy(curr_dict,curr_dict["timesteps"][i],use_mult))
        curr_str = str(curr_dict["timesteps"][i])+" "+str(round(en[i],4))+ str("\n")
        file.write(curr_str)
        print(i)
    file.close()