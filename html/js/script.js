window.addEventListener('message', function(event){
    if(event.data.action == "show"){
        document.getElementById(event.data.classname).innerHTML = event.data.text;
        event = null;
    } else if(event.data.action == "showandhighlight"){
        document.getElementById(event.data.classname).innerHTML = event.data.text;
        document.getElementById(event.data.classname).classList.add('highlight');
        setTimeout(() => document.getElementById(event.data.classname).classList.remove('highlight'), 1000);
        setTimeout(() => event = null, 1000);
    } else if(event.data.action == "hide"){
        document.getElementById(event.data.classname).innerHTML = '';
        event = null;
    }
});