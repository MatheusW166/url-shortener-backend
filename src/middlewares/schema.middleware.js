function validateSchema(schema) {
  return (req, res, next) => {
    const { error, value } = schema.validate(req.body, {
      abortEarly: false,
      allowUnknown: true,
    });
    if (error?.details?.length) {
      return res.status(422).send({
        error: error.details.map((detail) => {
          const key = detail.context.key;
          return { [key]: detail.message };
        }),
      });
    }
    req.body = value;
    next();
  };
}

export default validateSchema;
