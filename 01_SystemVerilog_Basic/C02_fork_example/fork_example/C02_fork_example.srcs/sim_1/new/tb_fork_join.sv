`timescale 1ns / 1ps
`define MODE_0_1_2 0;



module tb_fork_join ();
localparam MODE = 4;
    //1
    if (MODE == 0) begin
        initial begin
            $timeformat(-9, 3, "ns");
            #1 $display("%t : start fork - join", $time);

            fork
                // task A
                #10 A_thread();
                // task B
                #20 B_thread();
                // task C
                #15 C_thread();
            join

            #10 $display("%t : end fork - join", $time);
        end
    end else if (MODE == 1) begin
        //2
        initial begin
            $timeformat(-9, 3, "ns");
            #1 $display("%t : start fork - join", $time);

            fork
                // task A
                #10 A_thread();
                // task B
                #20 B_thread();
                // task C
                #15 C_thread();
            join_any

            #10 $display("%t : end fork - join", $time);
        end
    end else if (MODE == 2) begin
        //3
        initial begin
            $timeformat(-9, 3, "ns");
            #1 $display("%t : start fork - join", $time);

            fork
                // task A
                #10 A_thread();
                // task B
                #20 B_thread();
                // task C
                #15 C_thread();
            join_none

            #10 $display("%t : end fork - join", $time);
        end
    end else if (MODE == 3) begin
        //4
        initial begin
            $timeformat(-9, 3, "ns");
            #1 $display("%t : start fork - join", $time);

            fork
                // task A
                #10 A_thread();

                fork
                    // task B
                    #20 B_thread();
                    #50 B_thread();
                join

                // task C
                #30 C_thread();
            join_any

            #10 $display("%t : end fork - join", $time);
        end
    end else if (MODE == 4) begin
        //5
        initial begin
            $timeformat(-9, 3, "ns");
            #1 $display("%t : start fork - join", $time);

            fork
                // task A
                A_thread();
                // task B
                B_thread();
                // task C
                C_thread();
            join_any

            #10 $display("%t : end fork - join", $time);
            disable fork; // fork 내에서 실행 중인 다른 프로세스들을 종료함
            $stop;
        end
    end


    //--------------case1,2,3----------------

    // task A_thread();
    //     $display("%t : A thread", $realtime);
    // endtask  //A_thread

    // task B_thread();
    //     $display("%t : B thread", $realtime);
    // endtask  //B_thread

    // task C_thread();
    //     $display("%t : C thread", $realtime);
    // endtask  //C_thread

    //-----------case4,5---------------------
    task A_thread();
        repeat (5) $display("%t : A thread", $realtime);
    endtask  //A_thread
    task B_thread();
        forever begin
            $display("%t : B thread", $realtime);
            #5;
        end
    endtask  //B_thread

    task C_thread();
        forever begin
            $display("%t : C thread", $realtime);
            #10;
        end
    endtask  //C_thread





endmodule

