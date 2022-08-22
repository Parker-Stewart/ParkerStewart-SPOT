clear
clc
close all
%% Loading Data
file_9 = fullfile('ExperimentData_RED_2022_7_21_16_13','Parker_Velocity_Control_1__stitched.mat');
file_8 = fullfile('ExperimentData_RED_2022_7_22_12_22','Parker_Velocity_Control_1__stitched.mat');
file_6_5 = fullfile('ExperimentData_RED_2022_7_22_11_1','Parker_Velocity_Control_1__stitched.mat');

data_9 = load(file_9).rt_dataPacket;
data_8 = load(file_8).rt_dataPacket;
data_6_5 = load(file_6_5).rt_dataPacket;

%% Filtering
Torque_unFiltered_9 = data_9(400:700,72);
Torque_unFiltered_8 = data_8(400:725,72);
Torque_unFiltered_6_5 = data_6_5(400:850,72);

windowSize = 20; 
b = (1/windowSize)*ones(1,windowSize);
a = 1;

Torque_Filtered_9 = filter(b,a,Torque_unFiltered_9);
Torque_Filtered_8 = filter(b,a,Torque_unFiltered_8);
Torque_Filtered_6_5 = filter(b,a,Torque_unFiltered_6_5);

average_matrix = [mean(Torque_unFiltered_9), mean(Torque_Filtered_9);
                  mean(Torque_unFiltered_8), mean(Torque_Filtered_8);
                  mean(Torque_unFiltered_6_5), mean(Torque_Filtered_6_5);]

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
plot(Torque_unFiltered_6_5)
hold on
plot(Torque_Filtered_6_5)
%% Friction Curve
Torque_values = [average_matrix(1,1),average_matrix(2,1),-average_matrix(2,1),-average_matrix(1,1),-average_matrix(3,1),average_matrix(3,1),0.035,-0.035];
Velocity_values = [9,8,-8,-9,-5,5,0,0];

Gamma1 = 0.12; %Peak compared to plateau 0.014
Gamma2 = 5;
Gamma3 = 10;
Gamma4 = 0.039; %Static Friction 0.015
Gamma5 = 800; %Slope of Vertical Line
Gamma6 = 0.000001;

q_dot_t = -10:0.1:10;
d2r = pi/180;
r2d = 180/pi;
fqdot = Gamma1*(tanh(Gamma2*q_dot_t*d2r) - tanh(Gamma3*q_dot_t*d2r)) + Gamma4*tanh(Gamma5*q_dot_t*d2r) + Gamma6*q_dot_t*d2r;


figure 
plot(Velocity_values,Torque_values,'ob')
hold on 
plot(q_dot_t,fqdot,'k')
xlabel('Angular Velocity (rad/s)')
ylabel('Elbow Joint Friction Torque (Nm)')
legend('Experimental Friction','Fit Curve','location','NorthWest')
