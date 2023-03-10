# ======================================================================
# MAP GENERATOR FOR SHINRINX
# 
# STABLE
# 
# Usage:
# maptomars.py foldername inside /import
# 
# layout.txt format:
# firstline: objnames
# secondline and rest: layout data in words: 10x10
# ======================================================================

import sys
import os
    
# ======================================================================
# -------------------------------------------------
# Init
# -------------------------------------------------

# OBJECTS MUST BE AT THE CENTER IF YOU ARE EXPORTING FROM BLENDER
# 
# OR you can do this to the obj export script:
# CHANGE: me.transform(EXPORT_GLOBAL_MATRIX @ ob_mat)
# TO:     me.transform(EXPORT_GLOBAL_MATRIX)
SCALE_SIZE	  = 0x100

# reserved tags
TAG_NOMATERIAL	  = "MARSNULL"		  # Material is random color
TAG_MARSCOLOR	  = "MARSINDX"		  # Set specific pixel color (0-255): MARSINDX_indexnum
TAG_MARSINDX_LIST = "MARSLIST"            # Set index color in the material (for animated stuff)
TAG_TEXTUR        = "Textr_"		  # Tag for texture data in assembly
TAG_OBJECTSDIR    = "import"		  # Folder name that stores your objs (and material)
TAG_THISFOLDER    = "data/maps/3D/"       # Base folder

# ======================================================================
# -------------------------------------------------
# Start
# -------------------------------------------------

img_width     = 1 # failsafe.
img_height    = 1
num_vert      = 0
has_img       = False
use_img       = False
object_name   = sys.argv[1]
CONVERT_TEX   = True

INCR_Y=0
INDXBASE=0
if len(sys.argv) == 3:
  INCR_Y = sys.argv[2]
if len(sys.argv) == 4:
  INCR_Y = sys.argv[2]
  INDXBASE = sys.argv[3]
  
#if not os.path.exists("pz/"+object_name):
    #os.makedirs("pz/"+object_name)

#list_vertices = list()
#list_faces    = list()
list_mtrl     = list()
map_file      = open(TAG_OBJECTSDIR+"/layout.txt","r")
out_laydata   = open("out_map.bin","wb")
out_layout    = open("layout.asm","w")    # GENESIS SIDE, LABELS POINT TO SH2 VIEW
out_layoutm   = open("mars_data.asm","w") # SH2 SIDE
mappz_list    = map_file.readline().replace("\n","").split(" ")	

# ======================================================================
# -------------------------------------------------
# Read model pieces
# -------------------------------------------------

curr_pz=0
num_pz = len(mappz_list)
for curr_rdpz in range(0,num_pz):
  print("** Piece: "+mappz_list[curr_pz]+" **")
  model_file    = open(TAG_OBJECTSDIR+"/"+mappz_list[curr_pz]+".obj","r")
  material_file = open(TAG_OBJECTSDIR+"/"+mappz_list[curr_pz]+".mtl","r")	# CHECK BELOW
  out_head      = open("pz/"+mappz_list[curr_pz]+".asm","w")	# header
  out_vertices  = open("pz/"+mappz_list[curr_pz]+"_vert.bin","wb")	# vertices (points)
  out_faces     = open("pz/"+mappz_list[curr_pz]+"_face.bin","wb")	# faces
  #out_vertex    = open(object_name+"_vrtx.bin","wb")	# texture vertex (MOVED)
  out_mtrl      = open("pz/"+mappz_list[curr_pz]+"_mtrl.asm","w")

  vertex_list   = list()
  used_triangles= 0
  used_quads    = 0
  solidcolor    = 1
  random_color  = 1
  indx_color    = 0
  mtrl_curr     = 0
  mtrl_index    = 0

  reading=True
  random_mode   = True
  while reading:
    text=model_file.readline()
    if text=="":
      reading=False

    ## ---------------------------
    ## objects
    ## ---------------------------
    
    #if text.find("o") == False:
            #print("OBJECT")

    # ---------------------------
    # vertices
    # ---------------------------
    
    if text.find("v") == False: 
      a = text[2:]
      point = a.replace("\n","").split(" ")
      if point[0] != "":
        x=float(point[0])*SCALE_SIZE
        y=float(point[1])*SCALE_SIZE
        z=float(point[2])*SCALE_SIZE
        mars_x=int(x)
        mars_z=int(z)
        mars_y=(int(y)*-1)+int(INCR_Y)
        
        #print(mars_x,mars_y,mars_z)
        
        #if FROM_BLENDER == True:		# Y pos
          #mars_y=(int(y*SCALE_SIZE)*-1)+int((SCALE_SIZE/2))
        #else:
          #mars_y=int(y*SCALE_SIZE)*-1

        # LONG
        out_vertices.write( bytes([
                mars_x >> 24 & 0xFF,
                mars_x >> 16 & 0xFF,
                mars_x >> 8 & 0xFF,
                mars_x & 0xFF,
                mars_y >> 24 & 0xFF,
                mars_y >> 16 & 0xFF,
                mars_y >> 8 & 0xFF,
                mars_y & 0xFF,
                mars_z >> 24 & 0xFF,
                mars_z >> 16 & 0xFF,
                mars_z >> 8 & 0xFF,
                mars_z & 0xFF
                ]) )
        num_vert += 1
          
    # ---------------------------
    # Vertex
    # ---------------------------
    
    if text.find("vt") == False:
      a = text[2:]
      point = a.replace("\n","").split(" ")
      
      b = float(point[2])-1
      a = b - b - b
      vertex_list.append(float(point[1]))
      vertex_list.append(a)
      vertex_list.append(0)
      vertex_list.append(0)

      ## if needed later
      #x=float(point[1])
      #y=float(point[2])
      #mars_x=int(x)
      #mars_y=int(y)
      #out_vertex.write( bytes([
                #mars_x >> 24 & 0xFF,
                #mars_x >> 16 & 0xFF,
                #mars_x >> 8 & 0xFF,
                #mars_x & 0xFF,
                #mars_y >> 24 & 0xFF,
                #mars_y >> 16 & 0xFF,
                #mars_y >> 8 & 0xFF,
                #mars_y & 0xFF,
                #]) )

    # ---------------------------
    # MATERIAL check
    # ---------------------------
    
    if text.find("usemtl") == False:
      material_file.seek(0)
      mtlname = text[7:].rstrip('\r\n')
      a = mtlname[:8]
      
      if a == TAG_NOMATERIAL:
        print("RANDOM INDEX Material")
        has_img = False
        use_img = False
        random_mode = True
        
      # SOLID COLOR normal
      elif a == TAG_MARSCOLOR:
        a = mtlname.split("_")
        #print(a)
        #out_mtrl.write("\t dc.l "+str(a[1])+","+str(0)+"\n")  <-- if needed
        #indx_color += 1
        indx_color = int(a[1])
        print("INDEX Material: Color",indx_color)
        #img_width = 1
        #img_height = 1
        has_img = False
        use_img = False
        random_mode = False

      elif a == TAG_MARSINDX_LIST:
        a = mtlname.split("_")
        out_mtrl.write("\t dc.l "+str(a[1])+","+str(0)+"\n")
        mtrl_curr = mtrl_index
        mtrl_index += 1
        print("INDEX Material: Color",indx_color)
        #img_width = 1
        #img_height = 1
        has_img = False
        use_img = False
        random_mode = False

      # TEXTURE
      else:
        use_img = True
        # MATERIAL FILE READ LOOP
        mtlread = True
        while mtlread:
          mtltext=material_file.readline()
          if mtltext=="":
              mtlread=False
        
          # Grab material section
          if mtltext.find("newmtl "+mtlname) == False:
              i = True
              while i:
                b = material_file.readline()
                if b=="":
                    i=False

                # filename
                if b.find("map_Kd") == False:
                    tex_fname = b[7:].rstrip('\r\n')
                    tex_file = open(tex_fname,"rb")
                    # COPYPASTED
                    tex_file.seek(1)
                    color_type = ord(tex_file.read(1))
                    image_type = ord(tex_file.read(1))
                  
                    if color_type == 1:
                      pal_start = ord(tex_file.read(1))
                      pal_start += ord(tex_file.read(1)) << 8
                      pal_len = ord(tex_file.read(1))
                      pal_len += ord(tex_file.read(1)) << 8
                      ignore_this = ord(tex_file.read(1))
                      has_pal = True
          
                    if image_type == 1:
                      img_xstart = ord(tex_file.read(1))
                      img_xstart += ord(tex_file.read(1)) << 8
                      img_ystart = ord(tex_file.read(1))
                      img_ystart += ord(tex_file.read(1)) << 8
                      img_width = ord(tex_file.read(1))
                      img_width += ord(tex_file.read(1)) << 8
                      img_height = ord(tex_file.read(1))
                      img_height += ord(tex_file.read(1)) << 8

                      img_pixbits = ord(tex_file.read(1))
                      img_type = ord(tex_file.read(1)) 
                      if (img_type >> 5 & 1) == False:
                          print("ERROR: TOP LEFT images only")
                          tex_file.close()
                          quit()
                      has_img = True
                      random_mode = False
                      
                      # register name
                      b = tex_fname.split("/")[-1:]
                      a = b[0].split(".")
                      outname = a[0]
                      list_mtrl.append(outname)
                      
                      if int(CONVERT_TEX) == True:
                        a = mtlname.split(".")
                        print("TEXTURE Material:",a[0])
                        has_img = True
                        output_file = open("mtrl/"+outname+"_pal.bin","wb")
                        d = pal_len
                        while d:
                          d -= 1
                          a = (ord(tex_file.read(1)) & 0xF8 ) << 7
                          a |= (ord(tex_file.read(1)) & 0xF8 ) << 2
                          a |= (ord(tex_file.read(1)) & 0xF8 ) >> 3
                          output_file.write( bytes([ ((a>>8)&0xFF) , (a&0xFF) ]))
                        output_file.close()
                        
                        art_file = open("mtrl/"+outname+"_art.bin","wb")
                        b = img_height
                        e = 0
                        while b:
                          c = img_width
                          while c:
                              a = ord(tex_file.read(1))
                              art_file.write( bytes([a]) )
                              c -= 1
                          b -= 1
                          e += 1
                        art_file.close()

                    else:
                        print("IMAGE TYPE NOT SUPPORTED:",hex(image_type))
                        has_img = False
                        random_mode = False

                    out_mtrl.write("\t dc.l "+str(TAG_TEXTUR)+str(mtlname)+"|TH\n")
                    out_mtrl.write("\t dc.w "+str(img_width)+"\n")
                    out_mtrl.write("\t dc.w "+str(INDXBASE)+"\n")
                    
                    mtrl_curr = mtrl_index
                    mtrl_index += 1
                    tex_file.close()

    # ---------------------------
    # Faces
    # ---------------------------
    
    if text.find("f") == False:
      a = text[2:]
      point = a.split(" ")

      # Triangle
      if len(point) == 3:
        x_curr=point[0].split("/")
        y_curr=point[1].split("/")
        z_curr=point[2].split("/")

        # Set material id and size
        if use_img == True:
          a = 0x8000|0x4000|mtrl_curr&0x1FFF		# Texture mode | Triangle | mtrl_id
        else:
          if random_mode == True:
            a = 0x4000|random_color
            random_color += (1 & 0xFF)
            if random_color == 0:
              random_color = 1
          else:
            a = indx_color|0x4000
        out_faces.write( bytes([a>>8&0xFF,a&0xFF]) )      # TEXTURE ID

        # set texture
        if use_img == True:
          # TEXTURE POINTS
          x=int(x_curr[1])-1
          y=int(y_curr[1])-1
          z=int(z_curr[1])-1
          outx_l = x >> 8 & 0xFF
          outx_r = x & 0xFF
          outy_l = y >> 8 & 0xFF
          outy_r = y & 0xFF
          outz_l = z >> 8 & 0xFF
          outz_r = z & 0xFF
          out_faces.write(bytes([
                    outx_l,outx_r,
                    outy_l,outy_r,
                    outz_l,outz_r,
                    ]))
          a=img_width
          b=img_height
          c=(int(x_curr[1])-1)*4
          vertex_list[c+2]=a
          vertex_list[c+3]=b
          c=(int(y_curr[1])-1)*4
          vertex_list[c+2]=a
          vertex_list[c+3]=b
          c=(int(z_curr[1])-1)*4
          vertex_list[c+2]=a
          vertex_list[c+3]=b
        
        x=(int(x_curr[0])-1)*0x0C
        y=(int(y_curr[0])-1)*0x0C
        z=(int(z_curr[0])-1)*0x0C
        outx_l = x >> 8 & 0xFF
        outx_r = x & 0xFF
        outy_l = y >> 8 & 0xFF
        outy_r = y & 0xFF
        outz_l = z >> 8 & 0xFF
        outz_r = z & 0xFF
        out_faces.write(bytes([
                outx_l,outx_r,
                outy_l,outy_r,
                outz_l,outz_r,
                ]))

        used_triangles += 1
        
      # ---------------------------------
      # QUAD
      # ---------------------------------
      if len(point) == 4:
        x_curr=point[0].split("/")
        y_curr=point[1].split("/")
        z_curr=point[2].split("/")
        q_curr=point[3].split("/")

        # Set material id and size
        if use_img == True:
          a = 0x8000|mtrl_curr&0x1FFF		# Texture mode | mtrl_id
        else:
          if random_mode == True:
            a = random_color
            random_color += (1 & 0xFF)
            if random_color == 0:
              random_color = 1
          else:
            a = indx_color
        out_faces.write( bytes([a>>8&0xFF,a&0xFF]) )      # TEXTURE ID
        ## Set material id and size
        #if has_img == True:
          #a = mtrl_curr
          #b = 0x8000|4
        #else:
          #if random_mode == True:
            #a = random_color
            #random_color += (1 & 0xFF)
            #if random_color == 0:
              #random_color = 1
          #else:
            #a = indx_color
          #b = 4
        #out_faces.write( bytes([b>>8&0xFF,b&0xFF]) )      # NUMOF_POINTS
        #out_faces.write( bytes([a>>8&0xFF,a&0xFF]) )      # TEXTURE ID

        # TEXTURE POINTS
        # (material only)
        if has_img == True:
          x=int(x_curr[1])-1
          y=int(y_curr[1])-1
          z=int(z_curr[1])-1
          q=int(q_curr[1])-1
          outx_l = x >> 8 & 0xFF
          outx_r = x & 0xFF
          outy_l = y >> 8 & 0xFF
          outy_r = y & 0xFF
          outz_l = z >> 8 & 0xFF
          outz_r = z & 0xFF
          outq_l = q >> 8 & 0xFF
          outq_r = q & 0xFF
          out_faces.write(bytes([
                  outx_l,outx_r,
                  outy_l,outy_r,
                  outz_l,outz_r,
                  outq_l,outq_r,
                  ]))

          # set texture
          a=img_width
          b=img_height
          c=(int(x_curr[1])-1)*4
          vertex_list[c+2]=a
          vertex_list[c+3]=b
          c=(int(y_curr[1])-1)*4
          vertex_list[c+2]=a
          vertex_list[c+3]=b
          c=(int(z_curr[1])-1)*4
          vertex_list[c+2]=a
          vertex_list[c+3]=b
          c=(int(q_curr[1])-1)*4
          vertex_list[c+2]=a
          vertex_list[c+3]=b

        x=(int(x_curr[0])-1)*0x0C
        y=(int(y_curr[0])-1)*0x0C
        z=(int(z_curr[0])-1)*0x0C
        q=(int(q_curr[0])-1)*0x0C
        outx_l = x >> 8 & 0xFF
        outx_r = x & 0xFF
        outy_l = y >> 8 & 0xFF
        outy_r = y & 0xFF
        outz_l = z >> 8 & 0xFF
        outz_r = z & 0xFF
        outq_l = q >> 8 & 0xFF
        outq_r = q & 0xFF
        out_faces.write(bytes([
                outx_l,outx_r,
                outy_l,outy_r,
                outz_l,outz_r,
                outq_l,outq_r,
                ]))
          
        used_quads += 1

  #======================================================================
  # ----------------------------
  # Vertex convert
  # ----------------------------

  # TODO: check if texture points still work correctly

  cntr = len(vertex_list)
  if cntr != 0:
    out_vertex = open("pz/"+mappz_list[curr_pz]+"_vrtx.bin","wb")	# texture vertex

    x_tx = 0
    while cntr:
      x_l = int(vertex_list[x_tx+2] * vertex_list[x_tx])
      x_r = int(vertex_list[x_tx+3] * vertex_list[x_tx+1])
      out_vertex.write( bytes([
      x_l>>8&0xFF,x_l&0xFF,
      x_r>>8&0xFF,x_r&0xFF]))
      x_tx += 4
      cntr -= 4

    # padding
    b = out_vertex.tell()
    a = b & 0xF
    if a != 0:
      a = 0x10 - a
      out_vertex.write(bytes(a))
    out_vertex.close()

  # ----------------------------
  # face padding
  b = out_faces.tell()
  a = b & 0xF
  if a != 0:
    a = (0x10 - a)
    out_faces.write(bytes(a))

  # generate include
  out_head.write("MarsMapPz_"+mappz_list[curr_pz]+":\n")
  out_head.write("\t\tdc.w "+str(used_triangles+used_quads)+","+str(num_vert)+"\n") # numof_faces, numof_vertices
  out_head.write("\t\tdc.l TH|.vert,TH|.face,TH|.vrtx,TH|.mtrl\n")
  out_head.write('.vert:\t\tbinclude "'+TAG_THISFOLDER+object_name+'/pz/'+mappz_list[curr_pz]+'_vert.bin"\n')
  out_head.write('.face:\t\tbinclude "'+TAG_THISFOLDER+object_name+'/pz/'+mappz_list[curr_pz]+'_face.bin"\n')
  out_head.write('.vrtx:\t\tbinclude "'+TAG_THISFOLDER+object_name+'/pz/'+mappz_list[curr_pz]+'_vrtx.bin"\n')
  out_head.write('.mtrl:\t\tinclude "'+TAG_THISFOLDER+object_name+'/pz/'+mappz_list[curr_pz]+'_mtrl.asm"\n')
  out_mtrl.write("\t\talign 4\n")

  model_file.close()
  material_file.close()
  out_vertices.close()
  out_faces.close()
  out_mtrl.close()
  curr_pz += 1

out_head.write("\t\talign 4")
out_head.close()

#======================================================================
# ----------------------------
# Do layout
# ----------------------------

MAX_WIDTH = 0x20
MAX_HEIGHT = 0x20
while MAX_HEIGHT:
	b = map_file.readline().replace("\n","").replace("-","").split(" ")
	for i in range(0,MAX_WIDTH):
		#print(b[i])
		a = int(b[i],16)
		out_laydata.write(bytes([((a>>8)&0xFF),(a&0xFF)]))
	MAX_HEIGHT -= 1
	
out_layout.write("\t\tdc.l .blocks\n")
out_layout.write('\t\tbinclude "'+TAG_THISFOLDER+object_name+'/out_map.bin"\n\t\talign 4\n')
out_layout.write(".blocks:\n")

# TODO: automatic sort
out_layout.write("\t\tdc.l 0\n")
for i in range(0,len(mappz_list)):
	a = mappz_list[i]
	out_layout.write("\t\tdc.l MarsMapPz_"+a+"|TH\n")

for i in range(0,len(mappz_list)):
	a = mappz_list[i]
	out_layoutm.write('\t\tinclude "'+TAG_THISFOLDER+object_name+'/pz/'+a+'.asm"\n')
 		
#======================================================================
# ----------------------------
# End
# ----------------------------

print("Vert:",num_vert,"Face:",used_triangles+used_quads)
print("Poly:",used_triangles,"Quad:",used_quads)
out_laydata.close()
out_layout.close()
out_layoutm.close()
