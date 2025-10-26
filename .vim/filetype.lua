local function is_cloudformation(bufnr)
  local lines_to_check = 100
  for i = 1, lines_to_check do
    local line = vim.filetype.getlines(bufnr, i)
    if not line or #line == 0 then
      break
    end

    if vim.filetype.matchregex(line, [[AWSTemplateFormatVersion]]) or
       vim.filetype.matchregex(line, [[AWS::Serverless]]) or
       vim.filetype.matchregex(line, [[Transform:.*AWS::Serverless]]) or
       vim.filetype.matchregex(line, [[AWS::Lambda::]]) or
       vim.filetype.matchregex(line, [[AWS::S3::]]) or
       vim.filetype.matchregex(line, [[AWS::DynamoDB::]]) or
       vim.filetype.matchregex(line, [[AWS::EC2::]]) or
       vim.filetype.matchregex(line, [[AWS::IAM::]]) or
       vim.filetype.matchregex(line, [[AWS::RDS::]]) or
       vim.filetype.matchregex(line, [[AWS::SNS::]]) or
       vim.filetype.matchregex(line, [[AWS::SQS::]]) or
       vim.filetype.matchregex(line, [[AWS::CloudFormation::]]) or
       vim.filetype.matchregex(line, [[AWS::ApiGateway::]]) or
       vim.filetype.matchregex(line, [[AWS::StepFunctions::]]) then
      return true
    end
  end

  return false
end

local patterns = {}
local cfn_extensions = {
  ['.json'] = 'json.cloudformation',
  ['.yaml'] = 'yaml.cloudformation',
  ['.yml'] = 'yaml.cloudformation',
}
for ext, filetype in pairs(cfn_extensions) do
  patterns[ext] = {
    priority = math.huge,
    function(_path, bufnr)
      if is_cloudformation(bufnr) then
        return filetype
      end
    end,
  }
end

vim.filetype.add({ pattern = patterns })
