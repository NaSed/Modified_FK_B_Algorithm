function [bits]=rows_to_bits(bytes)

%% Compresses the rows of a 0-1 matrix into an integer matrix
%% whose bits give the old matrix.  So, the first column of the
%% original matrix becomes the least significant bits of the
%% first column of the new matrix, and so on.
%%
%% Copyright Utz-Uwe Haus and Tamon Stephen, January 2006.

int_size=32;

num_rows=size(bytes,1);
num_cols=size(bytes,2);
compact_cols=ceil(num_cols/32);
last_length=num_cols-int_size*(compact_cols-1);

bits=zeros(num_rows,compact_cols,'uint32');

for j=1:compact_cols
  last=int_size;          % Last column to fill.
  if (j==compact_cols)
    last=last_length;
  end
  for k=1:last
    line=uint32(bytes(:,int_size*(j-1)+k));
    bits(:,j)=bitset(bits(:,j),k,line);
  end
end
return

