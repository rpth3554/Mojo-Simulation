from python import Python
from time import sleep
from python.object import PythonObject
from tensor import Tensor, TensorSpec, TensorShape
from utils.index import Index
from random import rand



fn load_data(path: String,remember_selection:String):
    try:
        let time =  Python.import_module("time")
        let lass =  Python.import_module("lasso.dyna")
        
        print("in load")
        print("printing from load data function",path)
        print("plot option selection is ",remember_selection)
        

        let start_time = time.time()
        let loaded_file = lass.D3plot(path)
        let keyval = loaded_file.arrays.keys 
        
               
        
        let quantity_pstrain = loaded_file.arrays[lass.ArrayType.element_shell_effective_plastic_strain]
        let quantity_shell_nodes = loaded_file.arrays[lass.ArrayType.element_shell_node_indexes]
        let quantity_shell_ids = loaded_file.arrays[lass.ArrayType.element_shell_ids]
        
        var obj2 = PythonObject(none=None)
        # mean across all 3 integration points
        let pstrain_mean = quantity_pstrain.mean(2)


        # we only have 1 timestep here but let's take last one in general
        let last_timestep = -1
        let fringe_limits=(0, 0.03)
        let plotted=loaded_file.plot(-1, pstrain_mean[last_timestep], True,fringe_limits)
        let end_time = time.time()
        let elapsed_time = end_time - start_time
        print(elapsed_time)

    except:
        print("exception thrown")
        #pass        






def open_file_explorer()-> String:
    #global selected_file_path
    let tk = Python.import_module("tkinter")
    let filedialog = Python.import_module("tkinter.filedialog") 
    root = tk.Tk()
    root.withdraw()  # Hide the main window
    let selected_file_path = filedialog.askopenfilename()
    print(selected_file_path)
    
     
    #var py_instance = Python()
    #var mojo_str: StringRef = py_instance.__str__(selected_file_path)
    #my_object = selected_file_path  # Your object here
    #string_representation = my_object.to_string()
    #print("string rep is",string_representation)

    return selected_file_path.to_string()
    #return mojo_str





fn field_variable_selection(selected_item:PythonObject,counter:Int64)raises->String :
    
    let imgui =  Python.import_module("imgui")
    var function_bool=selected_item.__getitem__(0)
    var function_val=selected_item.__getitem__(1)  
    #print("function val at start is ",function_val)

    var field_var_type_first:String = PythonObject.to_string(selected_item)
    var field_var_type:String = PythonObject.to_string(selected_item)

    
    if function_val==1:
        print("Plastic Strain ")
        var field_var_type:String ="Plastic_Strain"    
        return field_var_type
    if function_val==2:
        print("eqv stress ")
        var field_var_type:String ="Eqv_Stress"    
        return field_var_type
    if function_val==3:
        print("Displacement magnitude ") 
        var field_var_type:String ="Displacement_Magnitude" 
        return field_var_type
    if function_val==4:
        print("Reaction Force ")
        var field_var_type:String ="Reaction_Force" 
        return field_var_type
    if function_val==5:
        print("Velocity") 
        var field_var_type:String ="Velocity" 
        return field_var_type
    if function_val==6:
        print("Acceleration")
        var field_var_type:String ="Acceleration" 
        return field_var_type
    
    #print(counter)
    if counter >0:
        if function_val >0:
            print("function val greater than 0")
            print("returning",field_var_type)
            return field_var_type
        else:
            return "Make a selection" 
    else:
        return "Make a selection"


fn exit(status: Int32) -> UInt8:
    return external_call["exit", UInt8, Int32](status)


fn  main() raises:
    
    
    #try:
        
        let imgui =  Python.import_module("imgui")
        let glfw =  Python.import_module("glfw")
        let GlfwRenderer = Python.import_module("imgui.integrations.glfw")
        let gl = Python.import_module("OpenGL.GL") 
        let tk = Python.import_module("tkinter")
        let filedialog = Python.import_module("tkinter.filedialog")    
        print("modules imported")
        if not glfw.init():
            return       

        let window = glfw.create_window(640, 480, "Web Result View 0.1", None, None)
        let cont = glfw.make_context_current(window)       
        let context = imgui.create_context()
        let impl = imgui.integrations.glfw.GlfwRenderer(window)
        var  state:String = "dumb path"
        print("state assigned dumb path outside of loop", state)
        var field_var:String= "Make a Selection"

        let v_sync_enable =glfw.swap_interval(1)
        var combo_selected_idx = 0
        var counter = 0
        var selection_print:String = "default"
        var remember_selection:String = "default"

            while not glfw.window_should_close(window):
                let v1 = glfw.poll_events()
                let v2 = impl.process_inputs()

                let clear_context = glfw.make_context_current(window)
                let color_clear = gl.glClearColor(0.4, 0.4, 0.4, 1)
                let all_clear=gl.glClear(gl.GL_COLOR_BUFFER_BIT)
                let v3 = imgui.new_frame()

                if imgui.begin_main_menu_bar():
                    if imgui.begin_menu("File", True):
                        let clicked_exit = imgui.menu_item( "Exit", '', False, True)
                        if clicked_exit:
                           print("exit")
                           _ = exit(0)
                        let end_men =imgui.end_menu()

                let end_menubar=imgui.end_main_menu_bar()
                let begin = imgui.begin("My Window", True)
                
                # Display the button and check if it's pressed
                if imgui.button("select d3plot file"):
                    var state_01:String = open_file_explorer()
                    state = state_01


                    print("state passed to var from function-now in main")
                    print(state)
                    print("state printed")



                

                var items = ["Field Variable","Plastic Strain", "Eqv Stress", "Displacement(Mag)", "Reaction Force", "Velocity","Acceleration"]
                var combo_selected_idx = imgui.combo(field_var, combo_selected_idx, items)
                var function_bool=combo_selected_idx.__bool__()
                
                var function_val=combo_selected_idx.__getitem__(1)
                
                field_var = field_variable_selection(combo_selected_idx,counter) 
                #print(field_var)
                if function_val>0:
                    counter+=1
                    remember_selection =field_var
                    field_var ="nothing"

                        
                var selection_print =imgui.text(remember_selection )

                if imgui.button("Load Simulation Results"):
                    load_data(state,remember_selection)

                let end = imgui.end()
                let render=imgui.render()
                let impl_render = impl.render(imgui.get_draw_data())
                let swap_buff = glfw.swap_buffers(window)



            let imp_shutdown=impl.shutdown()
            print("last selection is ",remember_selection) 
            let terminate = glfw.terminate()



    #except:
    #    print("exception thrown")
               

