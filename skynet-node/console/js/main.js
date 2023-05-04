// //////////////////////////////////////////////////////////////////////////Skynet/////////////
// main.js
// the framework for communicating with skynet server and displaying console in browser
// The actual communication routines (websockets) are in skynet.js
// ///////////////////////////////////////////////////////////////////////////////////////

class SkynetConsole {

    constructor() {
        let parent = this; // So we can pass this instance to function calls where needed

        this.skynet = new Skynet(); // object to hold base skynet function calls e.g. send_message

        // skynet message event_type:
        this.PPC_CONNECTED = "ppc_connected";
        this.PPC_DISCONNECTED = "ppc_disconnected";
        this.PPC_STATUS = "ppc_status";
        this.PPC_MSG = "ppc_msg";
        this.PPC_IDLE = "ppc_idle";
        this.PPC_RESERVED = "ppc_reserved";
        this.PPC_WAITING = "ppc_waiting";
        this.PPC_STARTING = "ppc_starting";          // 'run' command has been sent to PPC
        this.PPC_RUNNING = "ppc_running";
        this.PPC_SPLIT = "ppc_split";    // 'split' response from PPC
        this.PPC_NOSPLIT = "ppc_nosplit";    // 'nosplit' response from PPC
        this.PPC_COMPLETED = "ppc_completed";
        this.PPC_EXIT = "ppc_exit";
        this.SKYNET_WARNING = "skynet_warning";
        this.SKYNET_MSG = "skynet_msg";

        this.flow_node_names; // array of node names in order of hosts_area elements
        this.flow_node_index = {}; // mapping from node_name to index 0..flow_host_count-1
        this.flow_status; // array. holds current status value for each node
        //this.flow_row_status = PPC_IDLE; // current default 'status' for flow row (change triggers new row)

        this.zone_id = 'skynet';

        this.chart_el = document.getElementById("utilisation_chart");
        this.chart = null;
        this.prev_nodes_running = 0; // previous count of nodes in RUNNING status, used for chart steps

        // Here is where we receive 'shout' messages from the server, which
        // have been mapped to javascript custom events by skynet.js

        // listen for JavaScript events from Skynet socket
        window.addEventListener(
            "skynet_event",
            (e) => { parent.handle_skynet_event(e); },
            false
        );
    }

    on_load() {
        this.chart_init();
        this.skynet.init();
    }

    //---------------------------------------------------------------------------------------
    //------------------- HANDLE USER INPUT                              --------------------
    //---------------------------------------------------------------------------------------

    // triggered on button next to user text input field, or enter key
    user_text() {
        // get text input by user
        let user_input = document.getElementById('user_input').value;
        // write text to browser status area
        this.write_console('status_console_user', user_input);
        // send the user text as a message to skynet server

        // Detect start of "skynet bfp" run

        if (user_input.startsWith("skynet bfp")) {
            this.chart_reset();
        }

        this.skynet.skynet_send_msg('skynet', 'user_input', user_input);
        this.user_menu_hide();
    }

    // call 'user_text()' to execute the command chosen from the menu dropdown
    user_menu_command(el) {
        console.log('user_menu_command');
        // set text input as if by user
        document.getElementById('user_input').value = el.innerHTML;
        //alert(el.innerHTML);
        this.user_text();
    }

    // display the drop_down menu below the user command input box
    user_menu_show() {
        //alert('show_user_menu');
        console.log('show_user_menu');
        let user_menu = document.getElementById('user_input_menu');
        user_menu.setAttribute('class','user_input_menu_show');
    }

    // hide the drop_down menu below the user command input box
    user_menu_hide() {
        //alert('hide_user_menu');
        let user_menu = document.getElementById('user_input_menu');
        user_menu.setAttribute('class','user_input_menu_hide');
    }

    /*
    // set the logging/flow window to display the flow diagram
    user_status_flow() {
        document.getElementById('console_area').style.display = "none";
        document.getElementById('status_flow').style.display = "block";
    }

    user_status_console() {
        document.getElementById('status_flow').style.display = "none";
        document.getElementById('console_area').style.display = "block";
    }
    */

    // Triggered on user input of filter value for console log messages
    user_console_filter() {
        let filter_value = document.getElementById('console_filter').value;
        alert(filter_value);
        let console_list = document.getElementById("status_console");
        let rows = console_list.getElementsByTagName("li");
        for (let i=0; i < rows.length; i++) {
            if (rows[i].innerText.indexOf(filter_value) >= 0) {
                rows[i].style.display = "list-item";
            } else {
                rows[i].style.display = "none";
            }
        }
    }

    user_status_clear() {
        this.status_area_clear();
        this.flow_init();
    }

    timestamp() {
        let d = new Date();
        let h = ("0"+d.getHours()).slice(-2);
        let m = ("0"+d.getMinutes()).slice(-2);
        let s = ("0"+d.getSeconds()).slice(-2);
        let ms = ("000"+d.getMilliseconds()).slice(-3);
        return h+':'+m+':'+s+'.'+ms;
    }

    timestamp_ms() {
        let now  = new Date();
        if (this.run_start_time == null) {
            this.run_start_time = now;
            return 0;
        }
        return now - this.run_start_time;
    }

    //---------------------------------------------------------------------------------------
    //------------------- FUNCTIONS FROM USER MENU                       --------------------
    //---------------------------------------------------------------------------------------

    user_split(host_name, slot_name) {
        this.skynet.skynet_send_msg('skynet', 'user_input', 'skynet split '+host_name+' '+slot_name);
    }

    user_kill(host_name, slot_name) {
        this.skynet.skynet_send_msg('skynet', 'user_input', 'skynet kill '+host_name+' '+slot_name);
    }

    user_disconnect(host_name, slot_name) {
        this.skynet.skynet_send_msg('skynet', 'user_input', 'skynet disconnect '+host_name+' '+slot_name);
    }

    user_send(host_name, slot_name) {
        // get text input by user
        let user_input = document.getElementById('user_input').value;
        // write text to browser status area
        this.write_console('status_console_user', host_name+':'+slot_name+'~ '+user_input);
        this.skynet.skynet_send_msg('skynet', 'user_input', 'skynet send '+host_name+' '+slot_name+' '+user_input);
    }

    //---------------------------------------------------------------------------------------
    //------------------- UTILISATION CHART                              --------------------
    //---------------------------------------------------------------------------------------

    chart_init() {
        this.chart = Highcharts.chart(this.chart_el, {
            chart:{
                type:'scatter'
            },
            title:{
                text:''
            },
            subTitle:{
                text:''
            },
            plotOptions:{
                scatter:{
                    lineWidth:2
                }
            },
            xAxis: {
                title: { text: 'time' },
                labels: { format: '{value} ms' },
                min: 0,
                max: 300000,
                tickInterval: 10000
            },
            yAxis: {
                title: { text: 'active' },
                labels: { format: '{value}' },
                min: 0
            },
            series: [
                {
                    marker: {
                        enabled: false
                    },
                    data: [[0,0]]
                }],
            legend: { enabled: false }
        });
    }

    chart_reset() {
        this.chart.series[0].setData([]);
        this.run_start_time = new Date();
    }

    chart_update() {
        // DEBUG remove this 'return' statement
        //return;
        // Update the utilisation chart
        let nodes_running = this.node_running_count();
        let time_ms = this.timestamp_ms();
        // Add point to chart, with step, bools: redraw,shift,animation
        this.chart.series[0].addPoint([time_ms, this.prev_nodes_running], true, false, false);
        this.chart.series[0].addPoint([time_ms, nodes_running], true, false, false);
        this.prev_nodes_running = nodes_running;
    }

    //---------------------------------------------------------------------------------------
    //------------------- FUNCTIONS TRIGGERED BY INCOMING COMMANDS       --------------------
    //---------------------------------------------------------------------------------------

    // create 'id' for hosts_area element given host_name & slot_name
    make_host_button(host_name, slot_name) {
        return host_name+':'+slot_name+':button';
    }

    // make a node_name from host & slot
    make_nn(host_name, slot_name) {
        return host_name+':'+slot_name;
    }

    // process PPC_CONNECTED event from skynet server
    do_connect(host_name, slot_name) {
        console.log("main.js do_connect() "+host_name+":"+slot_name);

        /* E.g.
        <div id="skynet:slot7:button" class="host">
        <ul><li id="skynet:slot7" class="ppc_connected"><a href="#">skynet:slot4</a>
            <ul>
            <li><a href="#">Sub Menu 1</a></li>
            <li><a href="#">Sub Menu 2</a></li>
            <li><a href="#">Sub Menu 3</a></li>
            </ul>
            </li>
        </ul>
        </div>
        */

        // check to see if host_area element already exists for this node
        let node_name = this.make_nn(host_name, slot_name);

        let node_element = document.getElementById(node_name);
        if (node_element) {
            console.log("main.js do_connect() existing page element "+node_name);
            // if it exists, just set its background color to 'connected'
            let li = document.getElementById(this.make_host_button(host_name,slot_name));
            if (li) {
                li.setAttribute('class','ppc_connected');
            } else {
                console.log('Just received a disconnect for unknown node '+host_name+':'+slot_name);
            }
            return;
        }
        console.log("main.js do_connect() creating new page element "+node_name);

        // an existing host_area button doesn't exist for this node, so create one
        let div = document.createElement('DIV');
        div.setAttribute('id', node_name);
        div.setAttribute('class', 'host');
        let ul1 = document.createElement('UL');
        let li1 = document.createElement('LI');
        li1.setAttribute('id',this.make_host_button(host_name,slot_name));
        li1.setAttribute('class','ppc_idle');
        let a1 = document.createElement('A');
        a1.setAttribute('href','#');
        let displayname = document.createTextNode(node_name);
        a1.appendChild(displayname);
        let ul2 = document.createElement('UL');

        let a2 = document.createElement('A');
        let li2 = document.createElement('LI');
        let menu2 = document.createTextNode('Send Command');
        a2.setAttribute('href','javascript:user_send("'+host_name+'","'+slot_name+'");');
        a2.appendChild(menu2);
        li2.appendChild(a2);
        ul2.appendChild(li2);

        let a3 = document.createElement('A');
        let li3 = document.createElement('LI');
        let menu3 = document.createTextNode('menu2');
        a3.setAttribute('href','#');
        a3.appendChild(menu3);
        li3.appendChild(a3);
        ul2.appendChild(li3);

        let a4 = document.createElement('A');
        let li4 = document.createElement('LI');
        let menu4 = document.createTextNode('Split');
        a4.setAttribute('href','javascript:user_split("'+host_name+'","'+slot_name+'");');
        a4.appendChild(menu4);
        li4.appendChild(a4);
        ul2.appendChild(li4);

        let a5 = document.createElement('A');
        let li5 = document.createElement('LI');
        let menu5 = document.createTextNode('Kill');
        a5.setAttribute('href','javascript:user_kill("'+host_name+'","'+slot_name+'");');
        a5.appendChild(menu5);
        li5.appendChild(a5);
        ul2.appendChild(li5);

        let a6 = document.createElement('A');
        let li6 = document.createElement('LI');
        let menu6 = document.createTextNode('Disconnect');
        a6.setAttribute('href','javascript:user_disconnect("'+host_name+'","'+slot_name+'");');
        a6.appendChild(menu6);
        li6.appendChild(a6);
        ul2.appendChild(li6);

        li1.appendChild(a1);
        li1.appendChild(ul2);
        ul1.appendChild(li1);
        div.appendChild(ul1);

        document.getElementById('hosts_area').appendChild(div);

        // reset the status area
        this.status_area_clear();
        this.flow_init(); // this will update the top row with the correct number of nodes
    }

    // process PPC_DISCONNECTED event from skynet server
    do_disconnect(host_name, slot_name) {
        console.log("main.js do_disconnect() "+host_name+":"+slot_name);
        let li = document.getElementById(this.make_host_button(host_name,slot_name));
        if (li) {
            li.setAttribute('class','ppc_disconnected');
        } else {
            console.log('Just received a disconnect for unknown node '+host_name+':'+slot_name);
        }
    }

    // process PPC_MSG event from skynet server
    do_ppc_msg(host_name, slot_name, msg) {
        this.write_console('status_console_ppc', host_name+':'+slot_name+'~ '+msg);
    }

    do_ppc_status(host_name, slot_name, status) {
        switch (status) {
            case this.PPC_WAITING:
                this.do_ppc_waiting(host_name, slot_name);
                break;

            case this.PPC_RUNNING:
                this.do_ppc_running(host_name, slot_name);
                break;

            case this.PPC_IDLE:
                this.do_ppc_idle(host_name, slot_name);
                break;

            case this.PPC_RESERVED:                      // received during refresh
                this.do_ppc_reserved(host_name, slot_name);
                break;

            default:
                this.write_console('status_console_warning',"Unexpected PPC status: "+
                                host_name+" "+slot_name+ " "+status);
        }
    }

    // process PPC_WAITING event from skynet server
    do_ppc_waiting(host_name, slot_name) {
        console.log('do_ppc_waiting');
        let node_name = this.make_nn(host_name, slot_name);
        let li = document.getElementById(this.make_host_button(host_name,slot_name));
        if (li) {
            li.setAttribute('class','ppc_waiting');
            // update status flow diagram
            this.ppc_status_update(node_name, this.PPC_WAITING);
        } else {
            console.log('Just received a ppc_waiting status for unknown node '+host_name+':'+slot_name);
        }
    }

    // process PPC_RUNNING event from skynet server
    do_ppc_running(host_name, slot_name, task_info) {
        console.log('do_ppc_running',host_name,slot_name,task_info);
        let node_name = this.make_nn(host_name, slot_name);
        let li = document.getElementById(this.make_host_button(host_name,slot_name));
        if (li) {
            li.setAttribute('class','ppc_running');
            if (task_info) {
                this.do_ppc_msg(host_name, slot_name, "RUNNING "+task_info);
            }
            // update status flow diagram
            this.ppc_status_update(node_name, this.PPC_RUNNING);
        } else {
            console.log('Just received a ppc_running for unknown node '+host_name+':'+slot_name);
        }
    }

    // process PPC_SPLIT event from skynet server
    do_ppc_split(host_name, slot_name, split_info) {
        console.log('do_ppc_split',host_name,slot_name,split_info);
        let node_name = this.make_nn(host_name, slot_name);
        let li = document.getElementById(this.make_host_button(host_name,slot_name));
        if (li) {
            li.setAttribute('class','ppc_split');
            if (split_info) {
                this.do_ppc_msg(host_name, slot_name, "SPLIT "+split_info);
            }
            // update status flow diagram
            this.ppc_status_update(node_name, this.PPC_SPLIT);
        } else {
            console.log('Just received a ppc_split for unknown node '+host_name+':'+slot_name);
        }
    }

    // process PPC_NOSPLIT event from skynet server
    do_ppc_nosplit(host_name, slot_name) {
        console.log('do_ppc_nosplit',host_name,slot_name);
        let node_name = this.make_nn(host_name, slot_name);
        let li = document.getElementById(this.make_host_button(host_name,slot_name));
        if (li) {
            li.setAttribute('class','ppc_nosplit');
            this.do_ppc_msg(host_name, slot_name, "NOSPLIT");
            // update status flow diagram
            this.ppc_status_update(node_name, this.PPC_NOSPLIT);
        } else {
            console.log('Just received a ppc_nosplit for unknown node '+host_name+':'+slot_name);
        }
    }

    // process PPC_COMPLETED event from skynet server
    // task_info = PROC ORACLE G N WORK_COMPLETED e.g. "kappa 450 12 3 14"
    do_ppc_completed(host_name, slot_name, task_info) {
        console.log('do_ppc_completed',host_name,slot_name,task_info);
        let node_name = this.make_nn(host_name, slot_name);
        let li = document.getElementById(this.make_host_button(host_name,slot_name));
        if (li) {
            // note we reset node to 'LOADED' status
            li.setAttribute('class','ppc_waiting');
            this.do_ppc_msg(host_name, slot_name, "COMPLETED "+task_info)
            // update status flow diagram
            this.ppc_status_update(node_name, this.PPC_WAITING);
        } else {
            console.log('Just received a ppc_completed for unknown node '+host_name+':'+slot_name);
        }
    }

    // process PPC_EXIT event from skynet server
    do_ppc_exit(host_name, slot_name) {
        console.log('do_ppc_exit');
        this.do_ppc_idle(host_name, slot_name);
    }

    // process PPC_IDLE event from skynet server
    do_ppc_idle(host_name, slot_name) {
        console.log('do_ppc_idle');
        let node_name = this.make_nn(host_name, slot_name);
        let li = document.getElementById(this.make_host_button(host_name,slot_name));
        if (li) {
            // note we reset node to 'IDLE' status
            li.setAttribute('class','ppc_idle');
            // update status flow diagram
            this.ppc_status_update(node_name, this.PPC_IDLE);
        } else {
            console.log('Just received a ppc_idle for unknown node '+host_name+':'+slot_name);
        }
    }

    // process PPC_RESERVED event from skynet server
    do_ppc_reserved(host_name, slot_name) {
        console.log('do_ppc_reserved');
        let node_name = this.make_nn(host_name, slot_name);
        let li = document.getElementById(this.make_host_button(host_name,slot_name));
        if (li) {
            // note we reset node to 'RESERVED' status
            li.setAttribute('class','ppc_reserved');
            this.ppc_status_update(node_name, this.PPC_RESERVED);
        } else {
            console.log('Just received a ppc_reserved for unknown node '+host_name+':'+slot_name);
        }
    }

    //---------------------------------------------------------------------------------------
    //------------------- WRITE TO STATUS AREA IN LOG FORMAT             --------------------
    // i.e. scrolling lines of text, latest at the bottom
    //---------------------------------------------------------------------------------------

    status_area_clear() {
        // clear existing status console rows
        let myNode = document.getElementById('status_console');
        while (myNode.firstChild) {
            myNode.removeChild(myNode.firstChild);
        }
        // clear existing status flow rows
        myNode = document.getElementById('status_flow');
        while (myNode.firstChild) {
            myNode.removeChild(myNode.firstChild);
        }
    }

    // write text to browser status area
    write_console(status_class, text) {
        // add this text as a new 'user' line for the status area
        let new_line = document.createElement('LI');
        new_line.setAttribute('class',status_class);
        new_line.innerText = this.timestamp()+' '+text;
        //new_line.appendChild(line_text);
        document.getElementById('status_console').appendChild(new_line);
        /*
        let status_div = document.getElementById('status_area');
        status_div.scrollTop = status_div.scrollHeight;
        */
        new_line.scrollIntoView();
    }

    //---------------------------------------------------------------------------------------
    //------------------- DRAW THE STATUS FLOW DIAGRAM                   --------------------
    //---------------------------------------------------------------------------------------

    // initialize the status flow
    // i.e. reset vars and draw headings
    flow_init() {
        this.flow_node_names = new Array(); // cache the node names found while iterating the hosts_area children
        this.flow_status = new Array(); // will hold current status for each node
        this.flow_node_index = {};
        //flow_row_status = PPC_IDLE;
        let flow_node_count = 0;

        // iterate the nodes
        let host_elements = document.getElementById('hosts_area').children;
        for (let i=0; i<host_elements.length; i++) {
            if (host_elements[i].className == "host")
            {
                // for each 'host' element, increment count, cache node_name, and set flow_status
                let node_name = host_elements[i].id;
                this.flow_node_names[flow_node_count] = node_name;
                this.flow_node_index[node_name] = flow_node_count; // create cross-reference for node_name -> index
                //console.log('flow init flow_node_index[',node_name,'] =',flow_node_index[node_name]);
                this.flow_status[flow_node_count] = this.PPC_IDLE; // default initial status PPC_IDLE
                flow_node_count++;
            }
        }

        // add a TH element to "status_flow" for each host
        let tr = document.createElement('TR');
        // first add blank TH above timestamp column
        let blank_th = document.createElement('TH');
        let blank_th_text = document.createTextNode(' ');
        blank_th.appendChild(blank_th_text);
        tr.appendChild(blank_th);
        // now add a column for each node
        for (let i=0; i<this.flow_node_names.length; i++)
        {
            let th = document.createElement('TH');
            th.setAttribute('title',this.flow_node_names[i]);
            let th_text = document.createTextNode(i+1); // count from 1...
            th.appendChild(th_text);
            tr.appendChild(th);
        }
        document.getElementById('status_flow').appendChild(tr);
    }

    // return true if all nodes are in PPC_WAITING state
    status_flow_all_waiting() {
        for (let i=0; i<this.flow_node_names.length; i++) {
            if (this.flow_status[i] != this.PPC_WAITING) return false;
        }
        return true;
    }

    // some node status has changed, so it's time to output the current row
    flow_update() {
        // add a TH element to "status_flow" for each host
        let tr = document.createElement('TR');
        // add timestamp to start of row
        let td = document.createElement('TD');
        td.innerHTML = this.timestamp();
        tr.appendChild(td);
        // add column for status of each node
        for (let i=0; i<this.flow_node_names.length; i++) {
            let td = document.createElement('TD');
            td.className = this.flow_status[i];
            let status_element = document.createElement('SPAN');
            //console.log('flushing row flow_status[',i,'] is',flow_status[i]);
            switch (this.flow_status[i]) {
                case this.PPC_IDLE:
                    status_element.innerHTML = ':';
                    break;

                case this.PPC_CONNECTED:
                    status_element.innerHTML = 'C';
                    break;

                case this.PPC_WAITING:
                    status_element.innerHTML = '|';
                    break;

                case this.PPC_RUNNING:
                    status_element.innerHTML = 'R';
                    break;

                case this.PPC_SPLIT:
                    status_element.innerHTML = '*';
                    break;

                case this.PPC_NOSPLIT:
                    status_element.innerHTML = 'X';
                    break;

                default:
                    status_element.innerHTML = '?';
            }
            td.appendChild(status_element);
            tr.appendChild(td);
        }
        document.getElementById('status_flow').appendChild(tr);
        tr.scrollIntoView();

        // auto-scroll status_area to bottom of content
        //let status_div = document.getElementById('status_area');
        //status_div.scrollTop = status_div.scrollHeight;
    }

//---------------------------------------------------------------------------------------
//---------------------------------------------------------------------------------------
//---------------------------------------------------------------------------------------
//------------------- HANDLE THE SKYNET EVENTS, e.g. shouts          --------------------
//---------------------------------------------------------------------------------------
//---------------------------------------------------------------------------------------
//---------------------------------------------------------------------------------------

    handle_skynet_event(skynet_event) {
        console.log("handle_skynet_event",skynet_event);

        let msg = skynet_event.detail;

        console.log("skynet server msg: "+msg.host_name+":"+msg.slot_name+" "+msg.event_type+" "+msg.data);

        // ignore events not directed at this 'zone' of the browser window
        // main zone is zone 'skynet'
        if (msg.zone == this.zone_id)
        {
            console.log("main.js shout received for event_type", msg.event_type);
            switch (msg.event_type)
            {
                case this.PPC_CONNECTED:
                    console.log("main.js got PPC_CONNECTED message ",msg.host_name, msg.slot_name);
                    this.do_connect(msg.host_name, msg.slot_name);
                    break;
                case this.PPC_DISCONNECTED:
                    console.log("main.js got PPC_DISCONNECTED message ",msg.host_name, msg.slot_name);
                    this.do_disconnect(msg.host_name, msg.slot_name);
                    break;
                case this.PPC_STATUS:
                    console.log("main.js got PPC_STATUS message ",msg.host_name, msg.slot_name, msg.data);
                    this.do_ppc_status(msg.host_name, msg.slot_name, msg.data);
                    break;
                case this.PPC_COMPLETED:
                    console.log("main.js got PPC_COMPLETED message ",msg.host_name, msg.slot_name);
                    this.do_ppc_completed(msg.host_name, msg.slot_name, msg.data);
                    break;
                case this.PPC_RUNNING:
                    console.log("main.js got PPC_RUNNING message ",msg.host_name, msg.slot_name, msg.data);
                    this.do_ppc_running(msg.host_name, msg.slot_name, msg.data);
                    break;
                case this.PPC_SPLIT:
                    console.log("main.js got PPC_SPLIT message ",msg.host_name, msg.slot_name, msg.data);
                    this.do_ppc_split(msg.host_name, msg.slot_name, msg.data);
                    break;
                case this.PPC_NOSPLIT:
                    console.log("main.js got PPC_NOSPLIT message ",msg.host_name, msg.slot_name);
                    this.do_ppc_nosplit(msg.host_name, msg.slot_name);
                    break;
                case this.PPC_EXIT:
                    console.log("main.js got PPC_EXIT message ",msg.host_name, msg.slot_name);
                    this.do_ppc_exit(msg.host_name, msg.slot_name);
                    break;
                case this.PPC_MSG:
                    console.log("main.js got PPC_MSG message ",msg.host_name, msg.slot_name);
                    this.do_ppc_msg(msg.host_name, msg.slot_name, msg.data);
                    break;
                case this.SKYNET_WARNING:
                    console.log("main.js got SKYNET_WARNING message ",msg.data);
                    this.write_console('status_console_warning', "Skynet warning: "+msg.data);
                    break;
                default:
                    console.log("main.js process_shout unknown event:", skynet_event);
                    document.getElementById('status_area').innerHTML += '<br/>From server: ' + JSON.stringify(skynet_event);
            }
        }

        this.flow_update();
        this.chart_update();
    }

    node_running_count() {
        let running_count = 0;
        for (let i=0; i<this.flow_status.length; i++) {
            if (this.flow_status[i] == this.PPC_RUNNING) {
                running_count++;
            }
        }
        return running_count;
    }

    // Update the current row in the status flow, moving to new row if necessary
    ppc_status_update(node_name, status) {
        console.log('status_flow_update',node_name,status);
        //console.log('current row is',flow_row_status);
        let node_index = this.flow_node_index[node_name];
        //if (flow_row_status != status)
        //{
        //    status_flow_flush();
        //    flow_row_status = status;
        //}
        //console.log('update setting flow_status[',node_index,'] to',status);
        this.flow_status[node_index] = status;
    }

} // End class SkynetConsole

