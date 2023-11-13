import Foundation

// As a friendly reminder, we can create bookmarks for our code, which are special comments to help us jump to sections of the code on the mini-map to the right
//MARK: Creating Shapes
/* We have two types of shapes:
    - OvalShapes are created using a width and a height
    - PolygonShapes are created using an array of points
 */

// We'll create a bouncy ball (as a circle) to play our game

let ball = OvalShape(width: 40, height: 40)

// We'll create a few barriers (as rectangles) for our ball to bounce off of
var barriers: [Shape] = []

// We'll create the funnel (as a trapezoid), which we'll use to drop the ball from the top
let funnelPoints = [
    Point(x: 0, y: 50),
    Point(x: 80, y: 50),
    Point(x: 60, y: 0),
    Point(x: 20, y: 0)
]
let funnel = PolygonShape(points: funnelPoints)

// We'll create targets (as diamonds) for the ball to hit
var targets: [Shape] = []

//MARK: Setting up Shapes
/* We created separate functions to set up each shape individually, so that we could easily create as many barriers/targets as we want */

fileprivate func setupBall() {
    // onCollision, onExitedScene, and onTapped are special properties that can call other functions when the ball does something.
    // For example, "ball.onCollision" recognizes that the ball has hit another shape, and if it does, we'll change the color of the other shape using the "ballCollided()" function
    ball.position = Point(x: 250, y: 400)
    ball.hasPhysics = true
    ball.fillColor = .red
    ball.onCollision = ballCollided(with:)
    ball.isDraggable = false
    ball.onTapped = resetGame
    ball.onExitedScene = ballExitedScene
    scene.add(ball)
    scene.trackShape(ball)
    
    ball.bounciness = 0.6
}

fileprivate func addBarrier(at position: Point, width: Double, height: Double, angle: Double) {
    // we reworked our "setupBarrier" function into a more generalized "addBarrier" function, which can now create a barrier however and wherever we'd like
    
    let barrierPoints = [
        Point(x: 0, y: 0),
        Point(x: 0, y: height),
        Point(x: width, y: height),
        Point(x: width, y: 0)
    ]
    let barrier = PolygonShape(points: barrierPoints)
    barriers.append(barrier)    // after creating a new barrier, we'll add it to our list of barriers so that we can keep track of how many we have
    
    barrier.position = position
    barrier.hasPhysics = true
    barrier.isImmobile = true
    scene.add(barrier)
    
    barrier.angle = angle
}

fileprivate func setupFunnel() {
    // When we tap on the funnel, we'll call the "dropBall" function to have our ball drop from the funnel.
    funnel.position = Point(x: 200, y: scene.height - 25)
    funnel.onTapped = dropBall
    funnel.isDraggable = false
    scene.add(funnel)
}

func addTarget(at position: Point) {
    // Just like "addBarrier", we reworked this function to create a target and set the position ourselves
    // Each shape has a "name" property. We'll give every single target the same name ("target"), and since no other shape we've created has a name, we can use this property to distinguish between targets and other shapes.
    let targetPoints = [
        Point(x: 10, y: 0),
        Point(x: 0, y: 10),
        Point(x: 10, y: 20),
        Point(x: 20, y: 10)
    ]
    let target = PolygonShape(points: targetPoints)
    targets.append(target)    // after creating a new target, we'll add it to our list of targets so that we can keep track of how many we have
    
    target.position = position
    target.hasPhysics = true
    target.isImmobile = true
    target.fillColor = .blue
    target.isImpermeable = false
    target.name = "target"  // we'll use this to distinguish between targets and other shapes, since no other shape is using this property
    target.isDraggable = false
    scene.add(target)
}

//MARK: The Setup Function
// This function will set up the game for us, by calling the specific functions to set up each shape
func setup() {
    setupBall()
    setupFunnel()
    resetGame()
    
    // we'll create 4 different barriers with different positions, sizes, and angles
    addBarrier(at: Point(x: 200, y: 150), width: 80, height: 25, angle: 0.1)
    addBarrier(at: Point(x: 175, y: 100), width: 80, height: 25, angle: 0.1)
    addBarrier(at: Point(x: 100, y: 150), width: 30, height: 15, angle: -0.2)
    addBarrier(at: Point(x: 325, y: 150), width: 100, height: 25, angle: 0.3)
    
    // we'll create 6 different targets at different positions
    addTarget(at: Point(x: 184, y: 563))
    addTarget(at: Point(x: 238, y: 624))
    addTarget(at: Point(x: 269, y: 453))
    addTarget(at: Point(x: 213, y: 348))
    addTarget(at: Point(x: 113, y: 267))
    addTarget(at: Point(x: 150, y: 400))
}

//MARK: Other Functions
func dropBall() {
    // this function will set the ball's position to the funnel's, so that it looks like the ball is dropping out, and we'll turn off motion so that the ball doesn't fly off our screen.
    // When the ball is dropped, the barriers will be stuck in place until the ball is tapped or falls off the screen.
    ball.position = funnel.position
    ball.stopAllMotion()
    
    for barrier in barriers {
        barrier.isDraggable = false
    }
}

func ballCollided(with otherShape: Shape) {
    // We only want our targets to change color. Since the target is the only shape with a name, we can use that property to distinguish between our shapes: if "otherShape" is not a target, we'll exit the function and do nothing, otherwise we'll change the color.
    if otherShape.name != "target" { return }
    
    otherShape.fillColor = .green
}

func ballExitedScene() {
    // Once the ball leaves the screen, we'd be able to drag our barriers around
    // i figured out why we couldn't move the barriers! in the setupBall() function, I added the ball to the scene first before tracking it. Since the scene has a ball it can now track, we can see if it exits the scene and then we can successfully call this function
    for barrier in barriers {
        barrier.isDraggable = true
    }
    
    //the code on lines 147-156 will count how many targets we've hit (by looking for green-colored targets), and if we've hit everything, we'll get a message saying we've won!
    var hitTargets = 0
    for target in targets {
        if target.fillColor == .green {
            hitTargets += 1
        }
    }
    if hitTargets == targets.count {
        // line 155 will call a method for the scene called presentAlert(), which will make it so that when we win the game, we can get physical confirmation from the app itself via a pop-up alert.
        scene.presentAlert(text: "You won!", completion: alertDismissed)    //i added this to our project after class. This replaced the print("You won!!!") message i wrote
    }
}

func resetGame() {
    // We'll "reset" the ball by sending it 80 pixels above our screen, which will allow us to move the barriers around. To play the game, we just have to tap the funnel.
    ball.position = Point(x: 0, y: -80)
}

// I added this in post-class; the .presentAlert() method calls another function once the alert has been dismissed with the completion parameter, just like 'ball.onTapped' calls the 'resetGame' function.
// In other words, we need a function to control what should happen when the alert is dismissed. Since I don't want anything to happen, we'll create this function with nothing inside of it, just so we can at least call it in .presentAlert()
func alertDismissed() {}
