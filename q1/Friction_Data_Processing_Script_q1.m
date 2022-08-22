clear
clc
close all
%% Loading Data
file_10 = fullfile('ExperimentData_RED_2022_7_19_11_48','Parker_Velocity_Control_1_1.mat');
file_9 = fullfile('ExperimentData_RED_2022_7_19_14_33','Parker_Velocity_Control_1__stitched.mat');
file_8 = fullfile('ExperimentData_RED_2022_7_19_15_8','Parker_Velocity_Control_1__stitched.mat');
file_5 = fullfile('ExperimentData_RED_2022_7_20_13_16','Parker_Velocity_Control_1__stitched.mat');
file_1_2 = fullfile('ExperimentData_RED_2022_7_21_10_14','Parker_Velocity_Control_1__stitched.mat');
file_0_5 = fullfile('ExperimentData_RED_2022_7_19_16_36','Parker_Velocity_Control_2__stitched.mat');

data_10 = load(file_10).rt_dataPacket;
data_9 = load(file_9).rt_dataPacket;
data_8 = load(file_8).rt_dataPacket;
data_5 = load(file_5).rt_dataPacket;
data_1_2 = load(file_1_2).rt_dataPacket;
data_0_5 = load(file_0_5).rt_dataPacket;
%% Filtering
Torque_unFiltered_10 = data_10(384:end,71);
Torque_unFiltered_9 = data_9(500:end,71);
Torque_unFiltered_8 = data_8(378:end,71);
Torque_unFiltered_5 = data_5(382:530,71);
Torque_unFiltered_1_2 = data_1_2(400:1000,71);
Torque_unFiltered_0_5 = data_0_5(490:1243,71);

windowSize = 20; 
b = (1/windowSize)*ones(1,windowSize);
a = 1;

Torque_Filtered_10 = filter(b,a,Torque_unFiltered_10);
Torque_Filtered_9 = filter(b,a,Torque_unFiltered_9);
Torque_Filtered_8 = filter(b,a,Torque_unFiltered_8);
Torque_Filtered_5 = filter(b,a,Torque_unFiltered_5);
Torque_Filtered_1_2 = filter(b,a,Torque_unFiltered_1_2);
Torque_Filtered_0_5 = filter(b,a,Torque_unFiltered_0_5);

average_matrix = [mean(Torque_unFiltered_10), mean(Torque_Filtered_10);
                  mean(Torque_unFiltered_9), mean(Torque_Filtered_9);
                  mean(Torque_unFiltered_8), mean(Torque_Filtered_8);
                  mean(Torque_unFiltered_1_2), mean(Torque_Filtered_1_2);
                  mean(Torque_unFiltered_5), mean(Torque_Filtered_5);]

close all
figure
plot(Torque_unFiltered_10)
hold on
plot(Torque_Filtered_10)

figure
plot(Torque_unFiltered_9)
hold on
plot(Torque_Filtered_9)

figure
plot(Torque_unFiltered_8)
hold on
plot(Torque_Filtered_8)

figure
plot(Torque_unFiltered_1_2)
hold on
plot(Torque_Filtered_1_2)

figure
plot(Torque_unFiltered_0_5)
hold on
plot(Torque_Filtered_0_5)

figure
plot(Torque_unFiltered_5)
hold on
plot(Torque_Filtered_5)
%% Friction Curve
Torque_values = [average_matrix(2,2),average_matrix(3,2),-average_matrix(4,2),average_matrix(4,2),-average_matrix(3,2),-average_matrix(2,2),average_matrix(5,2),-average_matrix(5,2),0.0125,-0.0125];
Velocity_values = [9,8,1.2,-1.2,-8,-9,-5,5,0,0];

Gamma1 = 0.005; %Peak compared to plateau 0.014
Gamma2 = 5;
Gamma3 = 40;
Gamma4 = 0.015; %Static Friction 0.015
Gamma5 = 800; %Slope of Vertical Line
Gamma6 = 0.005;

q_dot_t = -10:0.1:10;
d2r = pi/180;
r2d = 180/pi;
fqdot = Gamma1*(tanh(Gamma2*q_dot_t*d2r) - tanh(Gamma3*q_dot_t*d2r)) + Gamma4*tanh(Gamma5*q_dot_t*d2r) + Gamma6*q_dot_t*d2r;


figure 
plot(Velocity_values,Torque_values,'ob')
hold on 
plot(q_dot_t,fqdot,'k')
xlabel('Angular Velocity (rad/s)')
ylabel('Shoulder Joint Friction Torque (Nm)')
legend('Experimental Friction','Fit Curve','location','NorthWest')
