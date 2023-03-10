exports.getDocument = function () {
  return {
    createElement : function (name) {
      var x =  {
        type : name,
        props : {},
        children : [],
      }
      var layout = {};
      if (name == "layout") {
        var layout = document.createElement("div")
      }
      x.layout = layout
      x.setAttribute = function(attr, value) {
        console.log("attr", attr, value)
        x.props[attr] = value
      }
      x.addEventListener = function (ev, listener) {
        console.log("ev", ev, listener)
        if(ev == "onClick") {
          layout.addEventListener('click', listener)
        }
        x.props[ev] = listener
      }
      const handler2 = {
        set(target, prop, value) {
          console.log("prop", prop, value)
          if (prop == "height") {
            layout.style.height= value
          } else if (prop == "width") {
            layout.style.width= value
          } else if (prop == "text") {
            layout.innerText = value
          }
          return target.props[prop] = value
        }
      };
      return new Proxy(x, handler2);;
    }
  }
}

exports.attachMachine = function (machine) {
  return function () {
    console.log(machine)
    document.body.appendChild(machine.value1.node.layout) 
  }
}