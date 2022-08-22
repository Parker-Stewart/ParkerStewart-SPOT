clear
clc
close all
%% Loading Data
file_9 = fullfile('ExperimentData_RED_2022_7_21_12_33','Parker_Velocity_Control_2__stitched.mat');
file_8 = fullfile('ExperimentData_RED_2022_7_21_12_39','Parker_Velocity_Control_1__stitched.mat');
file_5 = fullfile('ExperimentData_RED_2022_7_21_11_36','Parker_Velocity_Control_1__stitched.mat');

data_9 = load(file_9).rt_dataPacket;
data_8 = load(file_8).rt_dataPacket;
data_5 = load(file_5).rt_dataPacket;

%% Filtering
Torque_unFiltered_9 = data_9(400:end,73);
Torque_unFiltered_8 = data_8(500:end,73);
Torque_unFiltered_5 = data_5(600:780,73);

windowSize = 20; 
b = (1/windowSize)*ones(1,windowSize);
a = 1;

Torque_Filtered_9 = filter(b,a,Torque_unFiltered_9);
Torque_Filtered_8 = filter(b,a,Torque_unFiltered_8);
Torque_Filtered_5 = filter(b,a,Torque_unFiltered_5);

average_matrix = [mean(Torque_unFiltered_9), mean(Torque_Filtered_9);
                  mean(Torque_unFiltered_8), mean(Torque_Filtered_8);
                  mean(Torque_unFiltered_5), mean(Torque_Filtered_5);]

close all

figure
plot(Torque_unFiltered_9)
hold on
plot(Torque_Filtered_9)

figure
plot(Torque_unFiltered_8)
hold on
plot(Torque_Filtered_8)

figure
plot(Torque_unFiltered_5)
hold on
plot(Torque_Filtered_5)
%% Friction Curve
Torque_values = [average_matrix(1,1),average_matrix(2,1),-average_matrix(2,1),-average_matrix(1,1),-average_matrix(3,1),average_matrix(3,1),0.025,-0.025];
Velocity_values = [9,8,-8,-9,-5,5,0,0];

Gamma1 = 0.025; %Peak compared to plateau 0.014
Gamma2 = 5;
Gamma3 = 40;
Gamma4 = 0.029; %Static Friction 0.015
Gamma5 = 800; %Slope of Vertical Line
Gamma6 = 0.02;

q_dot_t = -10:0.1:10;
d2r = pi/180;
r2d = 180/pi;
fqdot = Gamma1*(tanh(Gamma2*q_dot_t*d2r) - tanh(Gamma3*q_dot_t*d2r)) + Gamma4*tanh(Gamma5*q_dot_t*d2r) + Gamma6*q_dot_t*d2r;


figure 
plot(Velocity_values,Torque_values,'ob')
hold on 
plot(q_dot_t,fqdot,'k')
xlabel('Angular Velocity (rad/s)')
ylabel('Wrist Joint Friction Torque (Nm)')
legend('Experimental Friction','Fit Curve','location','NorthWest')
