Shiny.addCustomMessageHandler("testmessage",
  function(message){
    var linksAndNodes = message;

    var dataURL = "https://ministryofjustice.github.io/form-builder-dependency-extraction/pa7-vis.json";

var svg = d3.select("svg"),
    width = +svg.attr("width"),
    height = +svg.attr("height");

// build the arrow.
svg.append("svg:defs").selectAll("marker")
    .data(["end"])      // Different link/path types can be defined here
  .enter().append("svg:marker")    // This section adds in the arrows
    .attr("id", String)
    .attr("viewBox", "0 -5 10 10")
    .attr("refX", 15)
    .attr("refY", -1.5)
    .attr("markerWidth", 6)
    .attr("markerHeight", 6)
    .attr("orient", "auto")
  .append("svg:path")
    .attr("d", "M0,-5L10,0L0,5");

//TODO make svg responsive
d3.select("div#form-network")
    .append("div")
    .classed("svg-container", true) //container class to make  responsive svg
    .append("svg")
    //responsive SVG needs these 2 attributes and no width and height attr
    .attr("preserveAspectRatio", "xMinYMin meet")
    .attr("viewBox", "0 0 8000 8000")
    //class to make it responsive
    .classed("svg-content-responsive", true);


var color = d3.scaleOrdinal(d3.schemeCategory20c);
var nodeRadius = 20;

var simulation = d3.forceSimulation()
    .force("link", d3.forceLink().id(function(d) {
        return d.id;
    }).distance(80))
    .force("charge", d3.forceManyBody().strength(-500))
    .force("center", d3.forceCenter(width / 2, height / 2))
    .force("collide", d3.forceCollide().radius(function(d) {
        return nodeRadius + 0.5; }).iterations(4))


d3.json(dataURL, function(error, graph) {
    if (error) throw error;

    simulation.nodes(graph.nodes);
    simulation.force("link").links(graph.links);

    var link = svg.append("g")
        .attr("class", "link")
        .attr("marker-end", "url(#end)")
        .selectAll("line")
        .data(graph.links)
        .enter().append("line");

    var node = svg.selectAll(".node")
      .data(graph.nodes)
      .enter().append("circle")
      .attr("class", "node")
      .attr("r", 5)
      .style("fill", function(d) { return color(d.group); })
      .attr("r", function(d) {
        if (d.hasOwnProperty('group')) {
            return d.group * 2 + 10;
        } else {
            return 9;
        }
       });

    node.append("svg:title")
        .attr("dx", 12)
        .attr("dy", ".35em")
        .text(function(d) {
            return d.id;
        });

    var labels = svg.append("g")
        .attr("class", "label")
        .selectAll("text")
        .data(graph.nodes)
        .enter().append("text")
        .attr("dx", 6)
        .attr("dy", ".35em")
        .style("font-size", 10)
        .text(function(d) {
            return d.id
        });
  

    simulation
        .nodes(graph.nodes)
        .on("tick", ticked);

    simulation.force("link")
        .links(graph.links);
  
  function ticked() {

    link.attr("x1", function(d) {
            return d.source.x;
        })
        .attr("y1", function(d) {
            return d.source.y;
        })
        .attr("x2", function(d) {
            return d.target.x;
        })
        .attr("y2", function(d) {
            return d.target.y;
        });

    node
        .attr("cx", function(d) {
            return d.x;
        })
        .attr("cy", function(d) {
            return d.y;
        });
    labels
        .attr("x", function(d) {
            return d.x;
        })
        .attr("y", function(d) {
            return d.y;
        }); 
}
 
});

function dragstarted(d) {
    if (!d3.event.active) simulation.alphaTarget(0.3).restart();
    d.fx = d.x;
    d.fy = d.y;
}

function dragged(d) {
    d.fx = d3.event.x;
    d.fy = d3.event.y;
}

function dragended(d) {
    if (!d3.event.active) simulation.alphaTarget(0);
    d.fx = null;
    d.fy = null;
}

  }
);
