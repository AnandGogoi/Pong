//
//  ContentView.swift
//  Pong
//
//  Created by Anand Gogoi on 11/30/21.
// the actual code for the phone screen
//

import SwiftUI
import SpriteKit
import GameplayKit

struct ContentView: View {
    
    // player one's paddle position 
    @State private var p1Position = CGPoint(x:200, y:100)
    //player one's paddle declaration. Makes the size and color of it
    @State private var p1 = Pixel(pwidth: 90, pheight: 15 , color: Color.blue)
    
    // player two's paddle position
    @State private var p2Position = CGPoint(x:200, y:775)
    //player two's paddle declaration. Makes the size and color of it
    @State private var p2 = Pixel(pwidth: 90, pheight: 15 , color: Color.blue)
    
    //ball declaration. Makes the size and color of it
    @State private var ball = Pixel (pwidth: 15, pheight: 15 , color: Color.orange)
    // player one's ball position
    @State private var ballPostion = CGPoint(x:205, y:450)
    // x direction of where the ball will go.
    @State private var bdx : CGFloat = 20
    // y direction of where the ball will go. goes at 45 degree angle when the game first states
    @State private var bdy : CGFloat = 20
    
    //timer to implement animation
    let timer = Timer.publish(every : 0.1, on: .main, in : .common).autoconnect()
    
    //player one's horizontal wall position
    @State private var b1position = CGPoint(x:200, y:60)
    //player one's horizontal wall declaration. Makes the size and color of it
    @State private var b1 = Pixel (pwidth: 1000, pheight: 7 , color: Color.orange)
    
    //player two's horizontal wall position
    @State private var b2position = CGPoint(x:205, y:810)
    //player two's horizontal wall declaration. Makes the size and color of it
    @State private var b2 = Pixel (pwidth: 1000, pheight: 7 , color: Color.orange)
    
    //player one's left movement button position
    @State private var l1Pos = CGPoint(x:30, y:80)
    //player two's left movement button position
    @State private var r1Pos = CGPoint(x:365, y:80)
    
    @State private var l2Pos = CGPoint(x:30, y:785)
    @State private var r2Pos = CGPoint(x:365, y:785)
    
    //player one's goal declaration. Makes the size and color of it
    @State private var g1 = Pixel (pwidth: 150, pheight: 15 , color: Color.cyan)
    //player one's goal position
    @State private var g1Position = CGPoint(x:200, y:60)
    
    //player two's horizontal goal. Makes the size and color of it
    @State private var g2 = Pixel (pwidth: 150, pheight: 15 , color: Color.cyan)
    //player two's horizontal wall position
    @State private var g2Position = CGPoint(x:205, y:810)
    
    // if the game is won or not
    @State private var gameNotWon = true;
    //if player one was the winner
    @State private var p1NotWon = false;
    //when the game should start
    @State private var startBool = false;
    
    // location of where the win message will be
    @State private var winMessage = CGPoint(x:200, y: 400)
    
    // screen layout
    var body: some View {
        GeometryReader{ geo in
            
            // displayes this screen if the game is not won. It is the actual game and uses all the compenents defined above.
            if gameNotWon {
                ZStack{
                    self.p1
                        .position(self.p1Position)
                    self.p2
                        .position(self.p2Position)

                    self.b1
                        .position(self.b1position)
                    self.b2
                        .position(self.b2position)
                    self.ball
                        .position(self.ballPostion)

                        .onReceive(self.timer) {_ in
                        moveBall()
                        }

                    Button ("<|", action: {
                        movePlayer(left : true, player: self.p1Position)
                    })
                    .position(self.l1Pos)
                    
                    
                    Button ("|>", action: {
                        movePlayer(left : false, player: self.p1Position)
                    })
                    .position(self.r1Pos)

                    Button ("<|", action:{
                        movePlayer2(left : true, player: self.p2Position)
                    })
                        .position(self.l2Pos)

                    Button ("|>", action: {
                        movePlayer2(left : false, player: self.p2Position)
                    })
                        .position(self.r2Pos)
                
                    self.g1
                        .position(self.g1Position)

                }
                .frame(width: geo.size.width, height: geo.size.height)
                .background(Color.cyan)
            
                ZStack{
                    if !startBool{
                        Button("start", action:{
                            startBool = true
                        })
                            .position(self.winMessage)
                    }
                    self.g2
                        .position(self.g2Position)
                
                }
                .frame(width: geo.size.width, height: geo.size.height)
                .background(Color.clear)
            }
            
            // displays this screen if the game has been finished. It has a restart button and states who won
            else {
                ZStack{
                    if self.p1NotWon{
                        Text("player 2 wins")
                            .foregroundColor(Color.blue)
                            .position(winMessage)
                    }
                    else{
                        Text("player 1 wins")
                            .foregroundColor(Color.blue)
                            .position(winMessage)
                    }
                    
                    Button(action:{
                            restart()
                        },
                        label:{
                            Text("restart")
                        }
                    )
                    
                }
                .frame(width: geo.size.width, height: geo.size.height)
                .background(Color.cyan)
                
            }
            
            
            
            
            
            
            
        }
        .edgesIgnoringSafeArea(.all)
    }
    
    // moves the ball
    func moveBall(){
        if self.startBool{
//            if (self.ballPostion.y >= 810 ){
//                self.ballPostion.x = self.ballPostion.x+self.bdx
//                self.ballPostion.y = self.ballPostion.y+self.bdy
//                self.gameNotWon = false
//            }
//            else if self.ballPostion.y < 60{
//                self.ballPostion.x = self.ballPostion.x+self.bdx
//                self.ballPostion.y = self.ballPostion.y+self.bdy
//                self.gameNotWon = false
//                self.p1NotWon = true
//            }
            // stops the game if the game has been won and resets all the variables
            if  ((self.ballPostion.x > (self.g1Position.x-self.g1.pwidth/2) &&  self.ballPostion.x < (self.g1Position.x+self.g1.pwidth/2 )) &&       self.ballPostion.y < 65){
                    withAnimation{
                        self.ballPostion.x = self.ballPostion.x+self.bdx
                        self.ballPostion.y = self.ballPostion.y+self.bdy
                        self.gameNotWon = false
                        self.p1NotWon = true
                    }

            }
            //stops the game if the game has been won and resets all the variables
            else if(self.ballPostion.x > (self.g2Position.x-self.g2.pwidth/2) &&            self.ballPostion.x < (self.g2Position.x+self.g2.pwidth/2 )) &&
                ( self.ballPostion.y >= 810){
                    withAnimation{
                        self.ballPostion.x = self.ballPostion.x+self.bdx
                        self.ballPostion.y = self.ballPostion.y+self.bdy
                        self.gameNotWon = false

                    }
            }
        
            else{
                // if it hits the right border it changes the direction
                if self.ballPostion.x >= 400{
                    bdx = -20
            
                }
                // if it hits the left border it changes the direction
                else if self.ballPostion.x <= 0{
                    bdx = 20
                
                }
                // if it hits player two's paddle or the bottom of the screen it changes directoin
                if self.ballPostion.y >= 810 || (self.ballPostion.y>768 && (self.ballPostion.x<self.p2Position.x+45 &&                                 self.ballPostion.x>self.p2Position.x-45)) {
                    bdy = -20
                
                }
                // it it hits player one's paddle or the top of the screen it changes direction
                else if self.ballPostion.y <= 60 || (self.ballPostion.y<107 &&          (self.ballPostion.x < self.p1Position.x+45 && self.ballPostion.x >   self.p1Position.x-45)) {
                        bdy = 20
                }
            }
        
            withAnimation{
                self.ballPostion.x = self.ballPostion.x+self.bdx
                self.ballPostion.y = self.ballPostion.y+self.bdy
            }
        }
    }
    
    // moves player one's paddle
    func movePlayer( left:Bool , player :CGPoint){
        withAnimation{
            
            if(self.p1Position.x >= 45 && left){
                self.p1Position.x = self.p1Position.x - 60
            }
            else if !left && self.p1Position.x <= 360{
                self.p1Position.x = self.p1Position.x + 30
            }
        }
    }
    
    // moves player 2's paddle
    func movePlayer2( left:Bool , player :CGPoint){
        withAnimation{
            if(self.p2Position.x >= 45 && left){
                self.p2Position.x = self.p2Position.x - 30
            }
            else if !left && self.p2Position.x <= 360{
                self.p2Position.x = self.p2Position.x + 30
            }
        }
    }
    
    // restarts the game by setting all the variable to their initial values
    func restart(){
        self.p1Position.x = 200
        self.p1Position.y = 100
        
        self.p2Position.x = 200
        self.p2Position.y = 775
        
        self.ballPostion.x = 205
        self.ballPostion.y = 450
        
        
        
        self.gameNotWon = true
        self.p1NotWon = false
        self.startBool = false
    }
    
    
    
    
    
        
}

