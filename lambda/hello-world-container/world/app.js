'use strict';
//Func endpoint for world
module.exports.world = async (event) => {
  return {
    statusCode: 200,
    body: JSON.stringify(
      {
        message: `World! Your function executed successfully!`,
      },
      null,
      2
    ),
  };
};
