##########################################
# D. artificial neural networks
##########################################
keras::unsearlize_model(object$finalModel$object)

control_ann <- trainControl(method="repeatedcv",
                            number = 10,
                            repeats = 5,
                            classProbs = T,
                            summaryFunction = twoClassSummary,
                            search = 'random',
                            allowParallel = TRUE)

model_ann <- train(form = Target ~.,
                   data = new_train_data,
                   method = "mlpKerasDropout",
                   preProc = c("center","scale"),
                   metric = "ROC",
                   trControl = control_ann,
                   tuneLength = 10,
                   epochs = 20)

# optimal hyperparameter
model_ann$bestTune
#performance grid
model_ann
# visualization
plot(model_ann)
# variable importance
importance_ann <- varImp(model_ann)
plot(importance_ann,col="#8470ff",main="Variable Importance (ANN)")


# prediction
ann_pred <- predict(model_ann,newdata = test_data[,-16]) 
ann_prob <- predict(model_ann,newdata = test_data[,-16],type = "prob") 
sum(ann_pred == 'yes')/sum(ann_pred == 'no')