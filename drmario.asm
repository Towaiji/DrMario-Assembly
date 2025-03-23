################# CSC258 Assembly Final Project ###################
# This file contains our implementation of Dr Mario.
#
# Student 1: Ali Towaiji, 1010545206
# Student 2: Ahmad ibrahim waqas, Student Number 
#
# We assert that the code submitted here is entirely our own 
# creation, and will indicate otherwise when it is not.
#
######################## Bitmap Display Configuration ########################
# - Unit width in pixels:       2
# - Unit height in pixels:      2
# - Display width in pixels:    64
# - Display height in pixels:   64
# - Base Address for Display:   0x10008000 ($gp)
##############################################################################

    .data
##############################################################################
# Immutable Data
##############################################################################
# The address of the bitmap display. Don't forget to connect it!
ADDR_DSPL:
    .word 0x10008000
# The address of the keyboard. Don't forget to connect it!
ADDR_KBRD:
    .word 0xffff0000

##############################################################################
# Mutable Data
capsule_x: .word 48      # Capsule X position (Column 12)
capsule_y: .word 384     # Capsule Y position (Row 3)
capsule_x_2: .word 48    # X position of the second half
capsule_y_2: .word 512   # Y position of the second half (Row 4)
capsule_color_1: .word 0  # Color of first half of capsule
capsule_color_2: .word 0  # Color of second half of capsule
capsule_orientation: .word 0  # 0 = vertical, 1 = horizontal, 2 = vertical (first half below), 3 = horizontal (first half right)
gravity_counter: .word 0      # Counter for gravity timing
gravity_speed: .word 30       # Number of frames between gravity updates
capsule_locked: .word 0       # Flag to indicate if the current capsule is locked
game_initialized: .word 0     # Flag to track if the game has been initialized
##############################################################################

##############################################################################
# Code
##############################################################################
	.text
	.globl main

    # Run the game.
main:
    # Initialize the game
    
    # Check if the game has already been initialized
    lw $t0, game_initialized
    bnez $t0, skip_initialization
    
    # Set the initialization flag
    li $t0, 1
    sw $t0, game_initialized
    # Initialize the game


    
 # -- medicine bottle --

    # left border
    lw $t0, ADDR_DSPL      # Load base address
    addi $t0, $t0, 12      # Move to column 3 (4 * 3)
    addi $t0, $t0, 640     # Move down to row 5 (128 * 5)
    li $t4, 0xFFFFFF       # White border color
    li $t6, 25             # Number of rows

left_border_loop:
    sw $t4, 0($t0)         # Draw white pixel
    addi $t0, $t0, 128     # Move down one row (32 units * 4 bytes)
    subi $t6, $t6, 1       # Decrease row count
    bgtz $t6, left_border_loop  # Repeat if more rows left

    # right border
    lw $t0, ADDR_DSPL      # Load base address
    addi $t0, $t0, 80      # Move to column 20 (4 * 20)
    addi $t0, $t0, 640     # Move down to row 5 (128 * 5)
    li $t4, 0xFFFFFF       # White border color
    li $t6, 25             # Number of rows

right_border_loop:
    sw $t4, 0($t0)         # Draw white pixel
    addi $t0, $t0, 128     # Move down one row (32 units * 4 bytes)
    subi $t6, $t6, 1       # Decrease row count
    bgtz $t6, right_border_loop  # Repeat if more rows left
 
    # bottom border
    lw $t0, ADDR_DSPL      # Load base address
    addi $t0, $t0, 12      # Move to column 3 (4 * 3)
    addi $t0, $t0, 3840    # Move down to row 30 (128 * 30)
    li $t4, 0xFFFFFF       # White border color
    li $t6, 18             # Number of column

bottom_border_loop:
    sw $t4, 0($t0)         # Draw white pixel
    addi $t0, $t0, 4       # Move right one column
    subi $t6, $t6, 1       # Decrease column count
    bgtz $t6, bottom_border_loop  # Repeat if more columns left

    # top border 1
    lw $t0, ADDR_DSPL      # Load base address
    addi $t0, $t0, 12      # Move to column 3 (4 * 3)
    addi $t0, $t0, 640     # Move down to row 5 (128 * 5)
    li $t4, 0xFFFFFF       # White border color
    li $t6, 7              # Number of column

top1_border_loop:
    sw $t4, 0($t0)         # Draw white pixel
    addi $t0, $t0, 4       # Move right one column
    subi $t6, $t6, 1       # Decrease column count
    bgtz $t6, top1_border_loop  # Repeat if more columns left

    # top border 2
    lw $t0, ADDR_DSPL      # Load base address
    addi $t0, $t0, 56      # Move to column 14 (4 * 14)
    addi $t0, $t0, 640     # Move down to row 30 (128 * 30)
    li $t4, 0xFFFFFF       # White border color
    li $t6, 7              # Number of column

top2_border_loop:
    sw $t4, 0($t0)         # Draw white pixel
    addi $t0, $t0, 4       # Move right one column
    subi $t6, $t6, 1       # Decrease column count
    bgtz $t6, top2_border_loop  # Repeat if more columns left

    # left bottleneck
    lw $t0, ADDR_DSPL      # Load base address
    addi $t0, $t0, 36      # Move to column 9 (4 * 9)
    addi $t0, $t0, 256     # Move down to row 2 (128 * 2)
    li $t4, 0xFFFFFF       # White border color
    li $t6, 3             # Number of rows

left_bottleneck_loop:
    sw $t4, 0($t0)         # Draw white pixel
    addi $t0, $t0, 128     # Move down one row (32 units * 4 bytes)
    subi $t6, $t6, 1       # Decrease row count
    bgtz $t6, left_bottleneck_loop  # Repeat if more rows left

    # right bottleneck
    lw $t0, ADDR_DSPL      # Load base address
    addi $t0, $t0, 56      # Move to column 14 (4 * 14)
    addi $t0, $t0, 256     # Move down to row 2 (128 * 2)
    li $t4, 0xFFFFFF       # White border color
    li $t6, 3              # Number of rows

right_bottleneck_loop:
    sw $t4, 0($t0)         # Draw white pixel
    addi $t0, $t0, 128     # Move down one row (32 units * 4 bytes)
    subi $t6, $t6, 1       # Decrease row count
    bgtz $t6, right_bottleneck_loop  # Repeat if more rows left
    
skip_initialization:
    
  # -- generate starting pill --

    # Generate First Half Color 
    li $v0, 42            # Random number generator
    li $a1, 3             # Generate a number between 0 and 2
    syscall               
    move $t5, $a0         # Store random number in $t5

    # Define three possible colors
    li $t1, 0xFF0000      # Red
    li $t2, 0x0000FF      # Blue
    li $t3, 0xFFFF00      # Yellow

    # Assign first capsule half color based on random number
    beq $t5, 0, first_red
    beq $t5, 1, first_blue
    beq $t5, 2, first_yellow
    
    j game_loop
first_red:
    move $t6, $t1         # Set first half to red
    sw $t1, capsule_color_1  # Store color in memory
    j second_color        # Jump to second color selection
first_blue:
    move $t6, $t2         # Set first half to blue
    sw $t2, capsule_color_1  # Store color in memory
    j second_color
first_yellow:
    move $t6, $t3         # Set first half to yellow
    sw $t3, capsule_color_1  # Store color in memory
    j second_color
    
second_color:
    # Generate Second Half Color 
    li $v0, 42            # Random number generator
    li $a0, 0
    li $a1, 3             # Generate a number between 0 and 2
    syscall             
    move $t5, $a0         # Store random number in $t5

    # Assign second capsule half color based on random number
    beq $t5, 0, second_red
    beq $t5, 1, second_blue
    beq $t5, 2, second_yellow

second_red:
    move $t7, $t1         # Set second half to red
    sw $t1, capsule_color_2  # Store color in memory
    j draw_capsule
second_blue:
    move $t7, $t2         # Set second half to blue
    sw $t2, capsule_color_2  # Store color in memory
    j draw_capsule
second_yellow:
    move $t7, $t3         # Set second half to yellow
    sw $t3, capsule_color_2  # Store color in memory
    j draw_capsule
    
draw_capsule:
    # Draw Capsule at Initial Position 
    lw $t0, ADDR_DSPL      # Load base address of the display
    addi $t0, $t0, 44      # Move to column 12 (4 * 12)
    addi $t0, $t0, 640     # Move down to row 3 (128 * 3)

    lw $t6, capsule_color_1  # Load first half color
    lw $t7, capsule_color_2  # Load second half color
    
    sw $t6, 0($t0)         # Draw first half of the capsule
    sw $t7, 4($t0)       # Draw second half below it
    
    # Initialize capsule position registers
    li $t0, 44             # X position of first half (Column 12)
    sw $t0, capsule_x      # Store X position
    li $t0, 640            # Y position of first half (Row 3)
    sw $t0, capsule_y      # Store Y position
    li $t0, 48             # X position of second half (same column)
    sw $t0, capsule_x_2    # Store X position
    li $t0, 640            # Y position of second half (one row below - Row 4)
    sw $t0, capsule_y_2    # Store Y position
    
    # Initialize capsule orientation (1 = horizontal)
    li $t0, 1
    sw $t0, capsule_orientation

    # Continue with generating next capsule and viruses
    j next_capsule
    
 # -- generate next capsule --
next_capsule:
    # Generate First Half Color for Next Capsule 
    li $v0, 42            # Random number generator
    li $a0, 0             # Use default generator (ID = 0)
    li $a1, 3             # Generate a number between 0 and 2
    syscall               # Execute syscall to get a random number
    move $t5, $a0         # Store random number in $t5

    # Assign first half color
    beq $t5, 0, next_red
    beq $t5, 1, next_blue
    beq $t5, 2, next_yellow

next_red:
    move $t8, $t1         # Set first half to red
    j next_second_color
next_blue:
    move $t8, $t2         # Set first half to blue
    j next_second_color
next_yellow:
    move $t8, $t3         # Set first half to yellow
    j next_second_color

next_second_color:
    # Generate Second Half Color for Next Capsule 
    li $v0, 42            # Random number generator
    li $a0, 0             # Use default generator (ID = 0)
    li $a1, 3             # Generate a number between 0 and 2
    syscall               # Execute syscall to get a random number
    move $t5, $a0         # Store new random number in $t5

    # Assign second half color
    beq $t5, 0, next2_red
    beq $t5, 1, next2_blue
    beq $t5, 2, next2_yellow

next2_red:
    move $t9, $t1         # Set second half to red
    j draw_next_capsule
next2_blue:
    move $t9, $t2         # Set second half to blue
    j draw_next_capsule
next2_yellow:
    move $t9, $t3         # Set second half to yellow
    j draw_next_capsule

draw_next_capsule:
    # Draw Next Capsule Outside the Bottle 
    lw $t0, ADDR_DSPL      # Load base address of the display
    addi $t0, $t0, 96      # Move to column 24 (4 * 24)
    addi $t0, $t0, 640     # Move down to row 5 (128 * 5)

    sw $t8, 0($t0)         # Draw first half of the capsule (random color)
    sw $t9, 128($t0)       # Draw second half next to it (random color)

# -- generate viruses --
generate_viruses:
    # Save return address
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    
    li $s0, 4             # Number of viruses to generate

virus_loop:
    # Generate Random X Position (Column) 
    li $v0, 42              # Random number generator
    li $a0, 0               # Use default generator (ID = 0)
    li $a1, 12              # Generate number between 0 and 11 
    syscall
    addi $t1, $a0, 5        # Shift to valid column range (columns 5 to 16)
    mul $t1, $t1, 4         # Convert column to memory offset (4 bytes per unit)

    # Generate Random Y Position (Row) 
    li $v0, 42              # Random number generator
    li $a0, 0               # Use default generator (ID = 0)
    li $a1, 20              # Generate number between 0 and 19 
    syscall
    addi $t2, $a0, 10       # Shift to valid row range (rows 10 to 29)
    mul $t2, $t2, 128       # Convert row to memory offset (128 bytes per row)

    # Generate Random Color 
    li $v0, 42              # Random number generator
    li $a0, 0               # Use default generator (ID = 0)
    li $a1, 3               # Generate number between 0 and 2 (3 colors)
    syscall
    move $t3, $a0           # Store random color choice

    # Define three possible colors
    li $t4, 0xFF0000        # Red
    li $t5, 0x0000FF        # Blue
    li $t6, 0xFFFF00        # Yellow

    # Assign color based on random number
    beq $t3, 0, virus_red
    beq $t3, 1, virus_blue
    beq $t3, 2, virus_yellow

virus_red:
    move $t7, $t4           # Set virus color to red
    j draw_virus
virus_blue:
    move $t7, $t5           # Set virus color to blue
    j draw_virus
virus_yellow:
    move $t7, $t6           # Set virus color to yellow
    j draw_virus

draw_virus: 
    lw $t0, ADDR_DSPL       # Load base address of display
    add $t0, $t0, $t1       # Add X offset (column)
    add $t0, $t0, $t2       # Add Y offset (row)

    sw $t7, 0($t0)          # Draw virus pixel

    subi $s0, $s0, 1        # Decrease virus count
    bgtz $s0, virus_loop    # Repeat until all viruses are placed
    
    # Restore return address
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    

##################### 
# Game loop
#####################

game_loop:
    # 1. Check if key has been pressed
    lw $t0, ADDR_KBRD            # Load the address of the keyboard
    lw $t1, 0($t0)               # Load the value at that address
    andi $t1, $t1, 1             # Check if the most significant bit is 1
    beqz $t1, update_game        # If not, continue game logic

    # A key has been pressed - get the key value
    lw $t2, 4($t0)               # Load the ASCII value of the key pressed
    
    # Check which key was pressed
    beq $t2, 97, move_left       # 'a' key - move left
    beq $t2, 100, move_right     # 'd' key - move right
    beq $t2, 119, rotate_capsule # 'w' key - rotate
    beq $t2, 115, drop_capsule   # 's' key - drop/move down
    beq $t2, 113, quit_game      # 'q' key - quit game
    
    j update_game                # Continue with game logic

move_left:
    # Before collision detection, temporarily clear the capsule
    jal clear_capsule

    # Check the first half's collision
    lw $t5, ADDR_DSPL
    lw $t3, capsule_x
    addi $t3, $t3, -4            # Position after moving left
    add $t5, $t5, $t3
    lw $t6, capsule_y
    add $t5, $t5, $t6
    lw $t7, 0($t5)               # Load color at position to the left
    bnez $t7, left_collision_found

    # Check the second half's collision if vertical (orientation 0 or 2)
    lw $t0, capsule_orientation
    beq $t0, 0, check_second_left_v
    beq $t0, 2, check_second_left_v

    # Otherwise, check horizontal orientations
    beq $t0, 1, check_second_left_h1
    beq $t0, 3, check_second_left_h2

    j update_left_position
    
check_second_left_v:
    lw $t5, ADDR_DSPL
    lw $t3, capsule_x_2          # Second half X
    addi $t3, $t3, -4            # Position after moving left
    add $t5, $t5, $t3
    lw $t6, capsule_y_2          # Second half Y
    add $t5, $t5, $t6
    lw $t7, 0($t5)               # Load color at position to the left
    bnez $t7, left_collision_found
    j update_left_position

    
check_second_left_h1:
    # For orientation 1, we also need to check the first half (leftmost)
    lw $t5, ADDR_DSPL
    lw $t3, capsule_x_2          # Second half X
    addi $t3, $t3, -4            # Position after moving left
    add $t5, $t5, $t3
    lw $t6, capsule_y_2          # Second half Y
    add $t5, $t5, $t6
    lw $t7, 0($t5)               # Load color at position to the left
    bnez $t7, left_collision_found
    j update_left_position
    
check_second_left_h2:
    # For orientation 3, we also need to check the second half (leftmost)
    lw $t5, ADDR_DSPL
    lw $t3, capsule_x_2          # Second half X
    addi $t3, $t3, -4            # Position after moving left
    add $t5, $t5, $t3
    lw $t6, capsule_y_2          # Second half Y
    add $t5, $t5, $t6
    lw $t7, 0($t5)               # Load color at position to the left
    bnez $t7, left_collision_found
    j update_left_position
    
left_collision_found:
    # Redraw the capsule since we cleared it for checking
    jal draw_capsule_at_position
    j update_game

update_left_position:
    # Update X position
    lw $t3, capsule_x
    addi $t3, $t3, -4            # Move left by 1 column (4 bytes)
    sw $t3, capsule_x            # Store new X position
    
    # Update second half position
    lw $t3, capsule_x_2
    addi $t3, $t3, -4            # Move left by 1 column
    sw $t3, capsule_x_2          # Store new X position
    
    j update_game
    
move_right:
    # Before collision detection, temporarily clear the capsule
    jal clear_capsule

    # Check the first half's collision
    lw $t5, ADDR_DSPL
    lw $t3, capsule_x
    addi $t3, $t3, 4             # Position after moving right
    add $t5, $t5, $t3
    lw $t6, capsule_y
    add $t5, $t5, $t6
    lw $t7, 0($t5)               # Load color at position to the right
    bnez $t7, right_collision_found

    # Check the second half's collision if vertical (orientation 0 or 2)
    lw $t0, capsule_orientation
    beq $t0, 0, check_second_right_v
    beq $t0, 2, check_second_right_v

    # Otherwise, check horizontal orientations
    beq $t0, 1, check_second_right_h1
    beq $t0, 3, check_second_right_h2

    j update_right_position
    
check_second_right_v:
    lw $t5, ADDR_DSPL
    lw $t3, capsule_x_2          # Second half X
    addi $t3, $t3, 4             # Position after moving right
    add $t5, $t5, $t3
    lw $t6, capsule_y_2          # Second half Y
    add $t5, $t5, $t6
    lw $t7, 0($t5)               # Load color at position to the right
    bnez $t7, right_collision_found
    j update_right_position

    
check_second_right_h1:
    # For orientation 1, we also need to check the second half (rightmost)
    lw $t5, ADDR_DSPL
    lw $t3, capsule_x_2          # Second half X
    addi $t3, $t3, 4             # Position after moving right
    add $t5, $t5, $t3
    lw $t6, capsule_y_2          # Second half Y
    add $t5, $t5, $t6
    lw $t7, 0($t5)               # Load color at position to the right
    bnez $t7, right_collision_found
    j update_right_position
    
check_second_right_h2:
    # For orientation 3, we also need to check the first half (rightmost)
    lw $t5, ADDR_DSPL
    lw $t3, capsule_x_2          # Second half X
    addi $t3, $t3, 4             # Position after moving right
    add $t5, $t5, $t3
    lw $t6, capsule_y_2          # Second half Y
    add $t5, $t5, $t6
    lw $t7, 0($t5)               # Load color at position to the right
    bnez $t7, right_collision_found
    j update_right_position
    
right_collision_found:
    # Redraw the capsule since we cleared it for checking
    jal draw_capsule_at_position
    j update_game

  update_right_position:
    # Update X position of the first half of the capsule
    lw $t3, capsule_x
    addi $t3, $t3, 4            # Move right by 1 column (4 bytes)
    sw $t3, capsule_x            # Store new X position
    
    # Update X position of the second half of the capsule
    lw $t3, capsule_x_2
    addi $t3, $t3, 4            # Move right by 1 column
    sw $t3, capsule_x_2          # Store new X position
    
    # Continue with the game loop
    j update_game


rotate_capsule:
    # Clear current capsule position
    jal clear_capsule

    # Get the current positions
    lw $t1, capsule_x            # First half X
    lw $t2, capsule_y            # First half Y
    lw $t3, capsule_x_2          # Second half X
    lw $t4, capsule_y_2          # Second half Y
    
    # Check current orientation
    lw $t0, capsule_orientation
    
    # Rotate based on current orientation
    addi $t0, $t0, 1             # Increment orientation
    andi $t0, $t0, 3             # Wrap around to 0 after reaching 3 (bitwise AND with 3)
    sw $t0, capsule_orientation  # Save new orientation
    
    # Calculate new position based on new orientation
    beq $t0, 0, set_vertical_up
    beq $t0, 1, set_horizontal_right
    beq $t0, 2, set_vertical_down
    beq $t0, 3, set_horizontal_left
    j update_game                # Should never reach here

set_vertical_up:
    # Vertical (first half on top)
    move $t3, $t1                # Same X as first half
    addi $t4, $t2, 128           # One row below first half
    j check_rotation_collision

set_horizontal_right:
    # Horizontal (first half on left)
    addi $t3, $t1, 4             # One column to the right
    move $t4, $t2                # Same Y as first half
    j check_rotation_collision

set_vertical_down:
    # Vertical (first half on bottom)
    move $t3, $t1                # Same X as first half
    subi $t4, $t2, 128           # One row above first half
    j check_rotation_collision

set_horizontal_left:
    # Horizontal (first half on right)
    subi $t3, $t1, 4             # One column to the left
    move $t4, $t2                # Same Y as first half
    j check_rotation_collision

check_rotation_collision:
    # Add boundary checks
    # Check if rotation would put capsule outside game area
    li $t5, 76                   # Maximum X position (column 19)
    li $t6, 16                   # Minimum X position (column 4)
    
    bgt $t3, $t5, revert_rotation # If beyond right edge, revert
    blt $t3, $t6, revert_rotation # If beyond left edge, revert
    
    # Check if there's a collision at the new position
    lw $t0, ADDR_DSPL            # Load display base address
    add $t0, $t0, $t3            # Add X offset of new position
    add $t0, $t0, $t4            # Add Y offset of new position
    lw $t5, 0($t0)               # Load color at new position
    bnez $t5, revert_rotation    # If not black (0), cannot rotate
    
    # If we reach here, there's no collision, so update the position
    j update_capsule_position

update_capsule_position:
    # Update second half position
    sw $t3, capsule_x_2          # Update second half X
    sw $t4, capsule_y_2          # Update second half Y
    
    # Add boundary checks
    # Check if rotation would put capsule outside game area
    lw $t0, capsule_x_2          # Load new X position
    li $t5, 76                   # Maximum X position (column 19)
    li $t6, 16                   # Minimum X position (column 4)
    
    bgt $t0, $t5, revert_rotation # If beyond right edge, revert
    blt $t0, $t6, revert_rotation # If beyond left edge, revert
    
    j update_game

revert_rotation:
    # Revert to previous orientation
    lw $t0, capsule_orientation
    subi $t0, $t0, 1             # Go back to previous orientation
    andi $t0, $t0, 3             # Wrap around (bitwise AND with 3)
    sw $t0, capsule_orientation  # Save reverted orientation
    
    # Restore previous positions
    lw $t3, capsule_x            # First half X stays the same
    lw $t4, capsule_y            # First half Y stays the same
    
    # Apply correct second half position based on reverted orientation
    beq $t0, 0, revert_vertical_up
    beq $t0, 1, revert_horizontal_right
    beq $t0, 2, revert_vertical_down
    beq $t0, 3, revert_horizontal_left

revert_vertical_up:
    # Vertical (first half on top)
    move $t3, $t1                # Same X as first half
    addi $t4, $t2, 128           # One row below first half
    j finish_revert

revert_horizontal_right:
    # Horizontal (first half on left)
    addi $t3, $t1, 4             # One column to the right
    move $t4, $t2                # Same Y as first half
    j finish_revert

revert_vertical_down:
    # Vertical (first half on bottom)
    move $t3, $t1                # Same X as first half
    subi $t4, $t2, 128           # One row above first half
    j finish_revert

revert_horizontal_left:
    # Horizontal (first half on right)
    subi $t3, $t1, 4             # One column to the left
    move $t4, $t2                # Same Y as first half
    j finish_revert

finish_revert:
    # Update second half position
    sw $t3, capsule_x_2          # Update second half X
    sw $t4, capsule_y_2          # Update second half Y
    
    j update_game

drop_capsule:
    # Check if capsule can move down first
    addi $sp, $sp, -4        # Save return address
    sw $ra, 0($sp)
    
    jal can_move_down        # Check if can move down
    lw $ra, 0($sp)           # Restore return address
    addi $sp, $sp, 4
    
    beqz $v0, update_game    # If can't move down, skip movement
    
    # Clear current capsule position
    jal clear_capsule

    # Update Y position (move down one row)
    lw $t3, capsule_y
    addi $t3, $t3, 128       # Move down by 1 row (128 bytes)
    sw $t3, capsule_y        # Store new Y position
    
    # Update second half position
    lw $t3, capsule_y_2
    addi $t3, $t3, 128       # Move down by 1 row
    sw $t3, capsule_y_2      # Store new Y position
    
    j update_game

clear_capsule:
    # Clear the current capsule position
    lw $t0, ADDR_DSPL            # Load display address
    lw $t3, capsule_x            # Load X position
    lw $t4, capsule_y            # Load Y position
    add $t0, $t0, $t3            # Add X offset
    add $t0, $t0, $t4            # Add Y offset
    
    # Clear first half
    sw $zero, 0($t0)             # Set to black (0)
    
    # Clear second half
    lw $t0, ADDR_DSPL            # Load display address again
    lw $t3, capsule_x_2          # Load second half X position
    lw $t4, capsule_y_2          # Load second half Y position
    add $t0, $t0, $t3            # Add X offset
    add $t0, $t0, $t4            # Add Y offset
    
    sw $zero, 0($t0)             # Set to black (0)
    
    jr $ra                       # Return

update_game:
    # Apply gravity
    jal apply_gravity
    
    # Redraw the capsule
    jal draw_capsule_at_position
    
    # Sleep for 16ms (approximately 60 FPS)
    li $v0, 32                   # syscall for sleep
    li $a0, 16                   # 16 milliseconds
    syscall
    
    j game_loop                  # Return to start of game loop

apply_gravity:
    # Save return address
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    
    # Check if it's time to apply gravity
    lw $t0, gravity_counter
    addi $t0, $t0, 1             # Increment counter
    sw $t0, gravity_counter
    
    lw $t1, gravity_speed
    blt $t0, $t1, gravity_done   # If counter < speed, skip gravity this frame
    
    # Reset counter
    sw $zero, gravity_counter
    
    # Check if capsule can move down
    jal can_move_down
    beqz $v0, lock_capsule       # If can't move down, lock the capsule
    
    # Clear current capsule position
    jal clear_capsule
    
    # Update Y position (move down one row)
    lw $t3, capsule_y
    addi $t3, $t3, 128           # Move down by 1 row (128 bytes)
    sw $t3, capsule_y            # Store new Y position
    
    # Update second half position
    lw $t3, capsule_y_2
    addi $t3, $t3, 128           # Move down by 1 row
    sw $t3, capsule_y_2          # Store new Y position
    
    j gravity_done

lock_capsule:
    # Set the capsule as locked
    li $t0, 1
    sw $t0, capsule_locked
    
    # Generate a new capsule
    jal spawn_new_capsule

gravity_done:
    # Restore return address
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra
    
# Add this function to check if the capsule can move down:
can_move_down:
    # Check if capsule would hit bottom border
    lw $t0, capsule_y            # Load Y position of first half
    lw $t1, capsule_y_2          # Load Y position of second half
    
    # Find the lower part of the capsule
    bgt $t1, $t0, use_second_half
    j use_first_half
    
use_second_half:
    move $t2, $t1                # Use Y of second half
    lw $t3, capsule_x_2          # Use X of second half
    j check_bottom
    
use_first_half:
    move $t2, $t0                # Use Y of first half
    lw $t3, capsule_x            # Use X of first half
    
check_bottom:
    addi $t2, $t2, 128           # Position after moving down
    li $t4, 3840                 # Position of bottom border (row 30)
    bge $t2, $t4, cannot_move    # If would hit bottom, can't move
    
    # Check for collision with viruses or other pills
    lw $t5, ADDR_DSPL            # Load display base address
    add $t5, $t5, $t3            # Add X offset
    add $t5, $t5, $t2            # Add Y offset after moving down
    lw $t6, 0($t5)               # Load color at position below
    bnez $t6, cannot_move        # If not black (0), there's a collision
    
    # Also check the other half of the pill for collisions
    lw $t0, capsule_orientation  # Get current orientation
    
    # For vertical orientation, only need to check bottom piece
    beq $t0, 0, check_vertical_up
    beq $t0, 2, check_vertical_down
    
    # For horizontal orientation, need to check both pieces
    beq $t0, 1, check_horizontal_right
    beq $t0, 3, check_horizontal_left
    
check_vertical_up:
    # Only need to check the bottom piece, already done above
    j collision_done
    
check_vertical_down:
    # Need to check the top piece
    lw $t3, capsule_x            # X of first half (bottom piece in this orientation)
    lw $t2, capsule_y            # Y of first half
    addi $t2, $t2, 128           # Position after moving down
    
    lw $t5, ADDR_DSPL            # Load display base address
    add $t5, $t5, $t3            # Add X offset
    add $t5, $t5, $t2            # Add Y offset after moving down
    lw $t6, 0($t5)               # Load color at position below
    bnez $t6, cannot_move        # If not black (0), there's a collision
    j collision_done
    
check_horizontal_right:
    # Check both pieces
    lw $t3, capsule_x_2          # X of second half (right piece)
    lw $t2, capsule_y_2          # Y of second half
    addi $t2, $t2, 128           # Position after moving down
    
    lw $t5, ADDR_DSPL            # Load display base address
    add $t5, $t5, $t3            # Add X offset
    add $t5, $t5, $t2            # Add Y offset after moving down
    lw $t6, 0($t5)               # Load color at position below
    bnez $t6, cannot_move        # If not black (0), there's a collision
    
    lw $t3, capsule_x            # X of first half (left piece)
    lw $t2, capsule_y            # Y of first half
    addi $t2, $t2, 128           # Position after moving down
    
    lw $t5, ADDR_DSPL            # Load display base address
    add $t5, $t5, $t3            # Add X offset
    add $t5, $t5, $t2            # Add Y offset after moving down
    lw $t6, 0($t5)               # Load color at position below
    bnez $t6, cannot_move        # If not black (0), there's a collision
    j collision_done
    
check_horizontal_left:
    # Check both pieces
    lw $t3, capsule_x            # X of first half (right piece in this orientation)
    lw $t2, capsule_y            # Y of first half
    addi $t2, $t2, 128           # Position after moving down
    
    lw $t5, ADDR_DSPL            # Load display base address
    add $t5, $t5, $t3            # Add X offset
    add $t5, $t5, $t2            # Add Y offset after moving down
    lw $t6, 0($t5)               # Load color at position below
    bnez $t6, cannot_move        # If not black (0), there's a collision
    
    lw $t3, capsule_x_2          # X of second half (left piece in this orientation)
    lw $t2, capsule_y_2          # Y of second half
    addi $t2, $t2, 128           # Position after moving down
    
    lw $t5, ADDR_DSPL            # Load display base address
    add $t5, $t5, $t3            # Add X offset
    add $t5, $t5, $t2            # Add Y offset after moving down
    lw $t6, 0($t5)               # Load color at position below
    bnez $t6, cannot_move        # If not black (0), there's a collision
    j collision_done
    
collision_done:
    # If no collision, can move down
    li $v0, 1                    # Return true (can move)
    jr $ra
    
cannot_move:
    li $v0, 0                    # Return false (cannot move)
    jr $ra

# Add this function to spawn a new capsule:
spawn_new_capsule:
    # Reset the capsule locked flag
    sw $zero, capsule_locked
    
    # Copy the colors from the "next" capsule to the current capsule
    move $t6, $t8                # Copy next capsule first half color
    move $t7, $t9                # Copy next capsule second half color
    
    sw $t6, capsule_color_1      # Store first half color
    sw $t7, capsule_color_2      # Store second half color
    
        # Reset capsule position (Horizontal spawn)
    li $t0, 44                   # X position of first half (Column 11)
    sw $t0, capsule_x
    li $t0, 640                  # Y position of first half (Row 5)
    sw $t0, capsule_y
    
    li $t0, 48                   # X position of second half (Column 12, right of first half)
    sw $t0, capsule_x_2
    li $t0, 640                  # Same row as the first half
    sw $t0, capsule_y_2
    
    # Set orientation to horizontal
    li $t0, 1                    # Orientation 1 means horizontal with first half on the left
    sw $t0, capsule_orientation

    
    # Clear the next capsule display area
    lw $t0, ADDR_DSPL            # Load base address of the display
    addi $t0, $t0, 96            # Move to column 24 (4 * 24)
    addi $t0, $t0, 640           # Move down to row 5 (128 * 5)
    sw $zero, 0($t0)             # Clear first half
    sw $zero, 128($t0)           # Clear second half
    
    # Generate new "next" capsule colors
    # Generate First Half Color for Next Capsule 
    li $v0, 42                   # Random number generator
    li $a0, 0                    # Use default generator (ID = 0)
    li $a1, 3                    # Generate a number between 0 and 2
    syscall                      # Execute syscall to get a random number
    move $t5, $a0                # Store random number in $t5

    # Define three possible colors
    li $t1, 0xFF0000             # Red
    li $t2, 0x0000FF             # Blue
    li $t3, 0xFFFF00             # Yellow

    # Assign first half color
    beq $t5, 0, next_spawn_red
    beq $t5, 1, next_spawn_blue
    beq $t5, 2, next_spawn_yellow

next_spawn_red:
    move $t8, $t1                # Set first half to red
    j next_spawn_second_color
next_spawn_blue:
    move $t8, $t2                # Set first half to blue
    j next_spawn_second_color
next_spawn_yellow:
    move $t8, $t3                # Set first half to yellow
    j next_spawn_second_color

next_spawn_second_color:
    # Generate Second Half Color for Next Capsule 
    li $v0, 42                   # Random number generator
    li $a0, 0                    # Use default generator (ID = 0)
    li $a1, 3                    # Generate a number between 0 and 2
    syscall                      # Execute syscall to get a random number
    move $t5, $a0                # Store new random number in $t5

    # Assign second half color
    beq $t5, 0, next_spawn2_red
    beq $t5, 1, next_spawn2_blue
    beq $t5, 2, next_spawn2_yellow

next_spawn2_red:
    move $t9, $t1                # Set second half to red
    j draw_next_spawn_capsule
next_spawn2_blue:
    move $t9, $t2                # Set second half to blue
    j draw_next_spawn_capsule
next_spawn2_yellow:
    move $t9, $t3                # Set second half to yellow
    j draw_next_spawn_capsule

draw_next_spawn_capsule:
    # Draw Next Capsule Outside the Bottle 
    lw $t0, ADDR_DSPL            # Load base address of the display
    addi $t0, $t0, 96            # Move to column 24 (4 * 24)
    addi $t0, $t0, 640           # Move down to row 5 (128 * 5)

    sw $t8, 0($t0)               # Draw first half of the capsule (random color)
    sw $t9, 128($t0)             # Draw second half next to it (random color)
    
    jr $ra                       # Return from function
    
draw_capsule_at_position:
    # Draw capsule at current position
    lw $t0, ADDR_DSPL            # Load display address
    lw $t3, capsule_x            # Load current X position
    lw $t4, capsule_y            # Load current Y position
    add $t0, $t0, $t3            # Add X offset
    add $t0, $t0, $t4            # Add Y offset
    
    # Load colors from memory
    lw $t6, capsule_color_1      # Load first half color
    lw $t7, capsule_color_2      # Load second half color
    
    # Draw first half
    sw $t6, 0($t0)               # Draw first half
    
    # Draw second half
    lw $t0, ADDR_DSPL            # Reload display address
    lw $t3, capsule_x_2          # Load second half X position
    lw $t4, capsule_y_2          # Load second half Y position
    add $t0, $t0, $t3            # Add X offset
    add $t0, $t0, $t4            # Add Y offset
    
    sw $t7, 0($t0)               # Draw second half
    
    jr $ra                       # Return

quit_game:
    # End the program
    li $v0, 10                   # Syscall code for exit
    syscall                      # Exit the program