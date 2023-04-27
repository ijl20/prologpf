
// Skynet class, used by main.js

// Creates a SkynetSocket for real-time connection to Skynet server

class Skynet {
    constructor() {
        this.server = location.protocol+'//'+location.hostname+(location.port ? ':'+location.port: '');

        console.log("Skynet(): defined server = "+this.server);

        this.title = "Skynet";

        this.skynet_socket = new SkynetSocket(); // used for websockets connection to Skynet server

        this.userid = this.query_string('userid'); //debug insecure

        // object to contain ready status if items by id
        // if item is ready, ready[id] == true
        var ready = {};

        // object to contain callbacks for ready items
        // e.g. for item X, ready_callback[X] is the function to call, with arg X
        var ready_callback = {};
    }

    init() {
        this.skynet_socket.init();
        //debug
        if (this.userid == "")
        {
            this.userid = 'anonymous';
        }

        // send connection user data
        //debug this should be done server-side...
        this.skynet_send_msg('skynet', 'person_joined');
    }

    // mainly debug function to set userid
    set_user(id, name) {
        if (id != null) {
            this.userid = id;
        }
    }

    // make a message object
    make_message(zone_id, event_type, data) {
        var msg = {};
        msg.userid = this.userid;
        //msg.page = this.page;

        msg.event_type = event_type;
        msg.zone = zone_id;
        msg.data = data;
        return msg;
    }

    // send message to Skynet server
    skynet_send_msg(zone_id, event_type, data) {
        if (this.skynet_socket == null || this.skynet_socket.socket == null)
        {
            console.log('skynet.js skynet_send_msg', zone_id, event_type ,'null socket');
            return;
        }
        var msg = this.make_message( zone_id, event_type, data);

        console.log('skynet.js skynet_send_msg:');
        this.log(msg);
        this.skynet_socket.socket.emit('message', msg);
    }

    //-----------------------------------------------------
    // log message in console
    //-----------------------------------------------------
    log(msg) {
        switch (msg.event_type)
        {
            default:
                console.log(msg);
        }
        return;
    }

    //------------------------------------------------------------
    // Functions to manage queue of callbacks for ready items

    // function called when an item is ready
    // e.g. in the onload callback of an image
    ready (id) {
        ready[id] = true;
        console.log("camxy.js ready[",id,"] set to true");
        if (ready_callback[id] != null)
        {
            ready_callback[id].forEach(function (callback)
            {
                console.log("camxy.js ready: ",id," with callbacks - calling now...");
                callback(id);
            });
            console.log('camxy.js callbacks complete for',id);
            delete(ready_callback[id]);
        }
    }

    // Request a callback be applied to an item when that item is ready
    apply_when_ready(id, callback) {
        if ( ready[id] == true )
        {
            console.log("camxy.js apply_when_ready: ",id," immediately ready so callback");
            callback(id);
        } else {
            if (ready_callback[id] == null) ready_callback[id] = new Array();
            ready_callback[id].push(callback);
            console.log("camxy.js apply_when_ready: ",id," will call callback");
        }
    }

    //------------------------------------------------------------
    // get querystring value X in ...?name=X&...
    query_string(name) {
        name = name.replace(/[\[]/, "\\\[").replace(/[\]]/, "\\\]");
        var regexS = "[\\?&]" + name + "=([^&#]*)";
        var regex = new RegExp(regexS);
        var results = regex.exec(window.location.search);
        if(results == null)
        return "";
        else
        return decodeURIComponent(results[1].replace(/\+/g, " "));
    }

}

class SkynetSocket {

    constructor() {
        this.socket = null;
    }

    init() {
        //debug errors not handled properly
        if (typeof io === 'undefined') {
            console.log("Error", "Cannot contact server");
        } else {
            this.socket = io.connect(skynet.server); // servername global in skynet.js

            this.socket.on('shout', this.receive_shout);
        }
    }

    // handle a received message from CamXY server
    receive_shout(shout_packet) {
        console.log("skynet.js shout received:", shout_packet);
        console.log("skynet.js shout data =", shout_packet.data);

        // if the message is not for this room, discard
        //debug - the server should track users by room and not send to all

        if (shout_packet.room != skynet.room)
        {
            console.log('camxy.js discarding shout for room',shout_packet.room, "( here is",skynet.room,")");
            return;
        }

        // JavaScript CustomEvent that CamXY server socket messages are mapped to
        // map socket messages to javascript events
        var skynet_event = document.createEvent("CustomEvent");

        // map the socket message to a javascript custom event...
        // the shout packet will be in event.detail
        skynet_event.initCustomEvent("skynet_event", true, true, shout_packet);
        window.dispatchEvent(skynet_event);
    }

}
