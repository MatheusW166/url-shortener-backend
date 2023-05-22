import Joi from "joi";

const createUserSchema = Joi.object({
  name: Joi.string().trim().required(),
  email: Joi.string().trim().email().required(),
  password: Joi.string().trim().required(),
  confirmPassword: Joi.string().trim().required().valid(Joi.ref("password")),
});

const loginUserSchema = Joi.object({
  email: Joi.string().trim().email().required(),
  password: Joi.string().trim().required(),
});

export { createUserSchema, loginUserSchema };
